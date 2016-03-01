require 'contentful/webhook/listener/controllers/wait'
require 'contentful/webhook/listener/webhooks'

module Contentful
  module Webhook
    module Listener
      module Controllers
        class WebhookAware < Wait
          attr_reader :webhook

          def publish
          end

          def unpublish
          end

          def archive
          end

          def unarchive
          end

          def save
          end

          def auto_save
          end

          def create
          end

          def delete
          end

          protected

          def perform(request, response)
            @webhook = WebhookFactory.new(request).create
            super(request, response)
            logger.debug "Webhook Data: {id: #{webhook.id}, space_id: #{webhook.space_id}, kind: #{webhook.kind}, event: #{webhook.event}}"
            send(webhook.event)
          rescue
            response.body = "Not a Webhook"
            response.status = 400
          end
        end
      end
    end
  end
end
