require 'net/http'

module Pushable
  class Event
    def initialize(model, event, channel=nil)
      @model = model
      @event = event
      @subchannel = channel
    end

    def broadcast
      post_form(uri, :message => message)
    end

    private

    def post_form(url, params)
      req = Net::HTTP::Post.new(url.path)
      req.form_data = params
      req.basic_auth url.user, url.password if url.user

      http = Net::HTTP.new(url.host, url.port)
      if url.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      http.start do |https|
        https.request(req)
      end
    end
  end
end
