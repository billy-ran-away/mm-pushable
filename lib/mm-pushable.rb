require 'mongo_mapper'
require 'mm-pushable/pushable'
require 'mm-pushable/event'

module Pushable
  NET_HTTP_EXCEPTIONS = [Timeout::Error, Errno::ETIMEDOUT, Errno::EINVAL,
                         Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError,
                         Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
                         Net::ProtocolError]

end
