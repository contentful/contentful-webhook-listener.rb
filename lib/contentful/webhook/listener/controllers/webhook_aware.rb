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

          def pre_perform(request, response)
            @webhook = WebhookFactory.new(request).create
          rescue Exception => e
            logger.error 'Not a Webhook. Stacktrace: '
            logger.error e
            response.body = "Not a Webhook"
            response.status = 400
          end

          def perform(request, response)
            super(request, response)

            logger.debug "Webhook Data: {id: #{webhook.id}, space_id: #{webhook.space_id}, kind: #{webhook.kind}, event: #{webhook.event}}"
            send(webhook.event)
          ensure
            response
          end
        end
      end
    end
  end
end
