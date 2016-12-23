require 'json'

module Contentful
  module Webhook
    module Listener
      module WebhookConstants
        WEBHOOK_TOPIC = 'x-contentful-topic'
        WEBHOOK_NAME = 'x-contentful-webhook-name'
      end

      class WebhookFactory
        def initialize(request)
          @headers = {}
          request.each { |header, value| @headers[header.downcase] = value }
          @body = JSON.load(request.body)
        end

        def create
          webhook_class.new(@headers, @body)
        end

        private

        def webhook_class
          Object.const_get(webhook_class_name)
        end

        def webhook_class_name
          event_name = @headers[::Contentful::Webhook::Listener::WebhookConstants::WEBHOOK_TOPIC].split('.')[-1].split('_').collect(&:capitalize).join
          "Contentful::Webhook::Listener::#{event_name}Webhook"
        rescue Exception
          fail 'Could not detect Webhook class'
        end
      end

      class BaseWebhook
        attr_reader :origin, :kind, :event, :raw_topic, :raw_headers, :raw_body, :id, :name, :space_id, :sys

        def initialize(headers, body)
          @raw_topic = headers[::Contentful::Webhook::Listener::WebhookConstants::WEBHOOK_TOPIC]
          @name = headers[::Contentful::Webhook::Listener::WebhookConstants::WEBHOOK_NAME]
          @origin, @kind, @event = @raw_topic.split('.')
          @raw_body = body
          @raw_headers = headers
          @sys = body['sys']
          @id = sys['id']
          @space_id = sys['space']['sys']['id']
        end

        def entry?
          kind == 'Entry'
        end

        def asset?
          kind == 'Asset'
        end

        def content_type?
          kind == 'ContentType'
        end
      end

      class FieldWebhook < BaseWebhook
        attr_reader :fields

        def initialize(headers, body)
          super(headers, body)
          @fields = body['fields']
        end
      end

      class PublishWebhook < FieldWebhook; end
      class SaveWebhook < FieldWebhook; end
      class AutoSaveWebhook < FieldWebhook; end
      class CreateWebhook < FieldWebhook; end
      class ArchiveWebhook < FieldWebhook; end
      class UnarchiveWebhook < FieldWebhook; end
      class UnpublishWebhook < BaseWebhook; end
      class DeleteWebhook < BaseWebhook; end
    end
  end
end
