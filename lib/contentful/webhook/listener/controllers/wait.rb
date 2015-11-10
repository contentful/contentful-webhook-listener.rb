require "thread"

module Contentful
  module Webhook
    module Listener
      module Controllers
        class Wait < Base
          attr_reader :timeout

          def initialize(server, wh_timeout, *options)
            super(server, options)
            @timeout = wh_timeout
          end

          protected
          def perform(request, response)
            sleep(self.timeout)
          end
        end
      end
    end
  end
end
