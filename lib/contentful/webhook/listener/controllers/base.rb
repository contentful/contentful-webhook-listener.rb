require "webrick"

module Contentful
  module Webhook
    module Listener
      module Controllers
        class Base < WEBrick::HTTPServlet::AbstractServlet
          def respond(request, response)
            response.body = ""
            response.status = 200

            Thread.new do
              perform(request, response)
            end
          end

          alias_method :do_GET, :respond
          alias_method :do_POST, :respond

          protected
          def perform(request, response)
            raise "must implement"
          end
        end
      end
    end
  end
end
