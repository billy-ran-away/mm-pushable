module Pushable
  extend ActiveSupport::Concern

  included do
    after_create :broadcast_create
    after_update :broadcast_update
    after_save :broadcast_save
    after_destroy :broadcast_destroy
  end

  def broadcast_save
    broadcast_event :touch
  end

  def broadcast_create
    broadcast_event :create
  end

  def broadcast_update
    broadcast_event :update
  end

  def broadcast_destroy
    broadcast_event :destroy
  end

  def broadcast_event(event)
    Event.new(self, event).broadcast
  rescue *NET_HTTP_EXCEPTIONS => e
    handle_net_http_exception e
  end

  def handle_net_http_exception(exception)
    ::Rails.logger.error("")
    ::Rails.logger.error("Backbone::Sync::Rails::Faye::Observer encountered an exception:")
    ::Rails.logger.error(exception.class.name)
    ::Rails.logger.error(exception.message)
    ::Rails.logger.error(exception.backtrace.join("\n"))
    ::Rails.logger.error("")
  end

  module ClassMethods
    def push(*args)
      options = args.extract_options!
      args = [ :all ] if args.empty?
      options[:on] ||= :all
      options[:to] ||= :self

      @pushes ||= {}
      Array.wrap(options[:on]).each do |event|
        @pushes[event] ||={}
        args.each do |attribute|
          @pushes[event][attribute] = Array.wrap options[:to]
        end
      end
    end

    def push_event?(event)
      if defined? @pushes
        @pushes.include? event or
        @pushes.empty? or
        @pushes.include? :all
      else
        true
      end
    end

    def push_changes_for?(event, attributes)
      if defined? @pushes
        Array.wrap(attributes).push(:all).any? do |attribute|
          (@pushes[:all].keys + (@pushes[event].try(keys) || [])).include? attribute
        end
      else
        true
      end
    end

    def push_changes_to(event, attributes)
      if defined? @pushes
        @pushes.values_at(:all, :update).inject([]) do |list, attribute_and_pushes|
          (list + (attribute_and_pushes.try(:values_at, :all, :name) || [])).flatten.uniq.reject(&:nil?)
        end
      else
        [ :self ]
      end
    end
  end
end
