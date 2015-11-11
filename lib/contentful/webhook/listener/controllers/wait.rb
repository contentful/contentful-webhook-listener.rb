require 'thread'

module Contentful
  module Webhook
    module Listener
      module Controllers
        # Wait Controller
        # Sleeps a determined amount of `:timeout` seconds on #perform
        class Wait < Base
          attr_reader :webhook_timeout

          def initialize(server, logger, wh_timeout, *options)
            super(server, logger, options)
            @webhook_timeout = wh_timeout
          end

          protected

          def perform(_request, _response)
            sleep(webhook_timeout)
          end
        end
      end
    end
  end
end
