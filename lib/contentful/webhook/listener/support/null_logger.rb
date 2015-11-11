module Contentful
  module Webhook
    module Listener
      module Support
        # NullLogger will silence any call to the :logger instance
        class NullLogger
          def write(_body)
            nil
          end

          alias_method :info, :write
          alias_method :debug, :write
          alias_method :warn, :write
          alias_method :error, :write
        end
      end
    end
  end
end
