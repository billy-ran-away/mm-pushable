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
    def broadcast(event, association, *options)
      @broadcast_events_and_options ||= {}
      @broadcast_events_and_options[event] ||={}
      @broadcast_events_and_options[event][association] = options
    end

    def broadcast_event?(event)
      @broadcast_events_and_options.include? event
    end

    def broadcast_to(event)
      @broadcast_events_and_options[event].keys
    end

    def broadcast_conditioned?(event, association)
      !@broadcast_events_and_options[event][association].blank?
    end
  end
end
