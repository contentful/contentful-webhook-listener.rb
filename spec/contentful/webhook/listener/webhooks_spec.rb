require 'spec_helper'

describe Contentful::Webhook::Listener::WebhookFactory do
  let(:body) { {sys: { id: 'foo', space: { sys: { id: 'space_foo' } } }, fields: {} } }
  let(:topic) { 'ContentfulManagement.Entry.publish' }
  let(:name) { 'WebhookName' }
  let(:request) { RequestDummy.new({'X-Contentful-Topic' => topic, 'X-Contentful-Webhook-Name' => name}, body) }
  subject { described_class.new(request) }


  describe 'instance methods' do
    describe '#create' do
      describe 'retrieves an instance of the correct webhook type' do
        it 'publish event creates a PublishWebhook' do
          webhook = described_class.new(RequestDummy.new({'X-Contentful-Topic' => 'ContentfulManagement.Entry.publish'}, body)).create
          expect(webhook).to be_a Contentful::Webhook::Listener::PublishWebhook
        end
        it 'save event creates a SaveWebhook' do
          webhook = described_class.new(RequestDummy.new({'X-Contentful-Topic' => 'ContentfulManagement.Entry.save'}, body)).create
          expect(webhook).to be_a Contentful::Webhook::Listener::SaveWebhook
        end
        it 'auto_save event creates an AutoSaveWebhook' do
          webhook = described_class.new(RequestDummy.new({'X-Contentful-Topic' => 'ContentfulManagement.Entry.auto_save'}, body)).create
          expect(webhook).to be_a Contentful::Webhook::Listener::AutoSaveWebhook
        end
        it 'create event creates a CreateWebhook' do
          webhook = described_class.new(RequestDummy.new({'X-Contentful-Topic' => 'ContentfulManagement.Entry.create'}, body)).create
          expect(webhook).to be_a Contentful::Webhook::Listener::CreateWebhook
        end
        it 'archive event creates a ArchiveWebhook' do
          webhook = described_class.new(RequestDummy.new({'X-Contentful-Topic' => 'ContentfulManagement.Entry.archive'}, body)).create
          expect(webhook).to be_a Contentful::Webhook::Listener::ArchiveWebhook
        end
        it 'unarchive event creates a UnarchiveWebhook' do
          webhook = described_class.new(RequestDummy.new({'X-Contentful-Topic' => 'ContentfulManagement.Entry.unarchive'}, body)).create
          expect(webhook).to be_a Contentful::Webhook::Listener::UnarchiveWebhook
        end
        it 'unpublish event creates a UnpublishWebhook' do
          webhook = described_class.new(RequestDummy.new({'X-Contentful-Topic' => 'ContentfulManagement.Entry.unpublish'}, body)).create
          expect(webhook).to be_a Contentful::Webhook::Listener::UnpublishWebhook
        end
        it 'delete event creates a DeleteWebhook' do
          webhook = described_class.new(RequestDummy.new({'X-Contentful-Topic' => 'ContentfulManagement.Entry.delete'}, body)).create
          expect(webhook).to be_a Contentful::Webhook::Listener::DeleteWebhook
        end
      end

      describe 'errors' do
        it 'raises an error when it cant detect webhook' do
          expect { described_class.new(RequestDummy.new({}, body)).create }.to raise_error "Could not detect Webhook class"
        end
      end
    end
  end
end

describe Contentful::Webhook::Listener::BaseWebhook do
  let(:body) { {'sys' => { 'id' => 'foo', 'space' => { 'sys' => { 'id' => 'space_foo' } } }, 'fields' => {} } }
  let(:topic) { 'ContentfulManagement.Entry.publish' }
  let(:name) { 'WebhookName' }
  let(:headers) { {'x-contentful-topic' => topic, 'x-contentful-webhook-name' => name} }
  subject { described_class.new(headers, body) }

  describe 'attributes' do
    it ':origin' do
      expect(subject.origin).to eq 'ContentfulManagement'
    end
    it ':kind' do
      expect(subject.kind).to eq 'Entry'
    end
    it ':event' do
      expect(subject.event).to eq 'publish'
    end
    it ':raw_topic' do
      expect(subject.raw_topic).to eq 'ContentfulManagement.Entry.publish'
    end
    it ':raw_body' do
      expect(subject.raw_body).to eq body
    end
    it ':id' do
      expect(subject.id).to eq 'foo'
    end
    it ':name' do
      expect(subject.name).to eq 'WebhookName'
    end
    it ':space_id' do
      expect(subject.space_id).to eq 'space_foo'
    end
    it ':sys' do
      expect(subject.sys).to eq body['sys']
    end
  end

  describe 'instance methods' do
    describe 'kind methods' do
      describe '#entry?' do
        it 'true when kind == Entry' do
          expect(described_class.new(headers, body).entry?).to be_truthy
        end
        it 'false when kind != Entry' do
          headers['x-contentful-topic'] = 'ContentfulManagement.Asset.publish'
          expect(described_class.new(headers, body).entry?).to be_falsey

          headers['x-contentful-topic'] = 'ContentfulManagement.ContentType.publish'
          expect(described_class.new(headers, body).entry?).to be_falsey
        end
      end
      describe '#asset?' do
        it 'true when kind == Asset' do
          headers['x-contentful-topic'] = 'ContentfulManagement.Asset.publish'
          expect(described_class.new(headers, body).asset?).to be_truthy
        end
        it 'false when kind != Asset' do
          expect(described_class.new(headers, body).asset?).to be_falsey

          headers['x-contentful-topic'] = 'ContentfulManagement.ContentType.publish'
          expect(described_class.new(headers, body).asset?).to be_falsey
        end
      end
      describe '#content_type?' do
        it 'true when kind == ContentType' do
          headers['x-contentful-topic'] = 'ContentfulManagement.ContentType.publish'
          expect(described_class.new(headers, body).content_type?).to be_truthy
        end
        it 'false when kind != ContentType' do
          expect(described_class.new(headers, body).content_type?).to be_falsey

          headers['x-contentful-topic'] = 'ContentfulManagement.Asset.publish'
          expect(described_class.new(headers, body).content_type?).to be_falsey
        end
      end
    end
  end
end

describe Contentful::Webhook::Listener::FieldWebhook do
  let(:body) { {'sys' => { 'id' => 'foo', 'space' => { 'sys' => { 'id' => 'space_foo' } } }, 'fields' => {} } }
  let(:topic) { 'ContentfulManagement.Entry.publish' }
  let(:name) { 'WebhookName' }
  let(:headers) { {'x-contentful-topic' => topic, 'x-contentful-webhook-name' => name} }
  subject { described_class.new(headers, body) }

  describe 'attributes' do
    it ':fields' do
      expect(subject.fields).to eq body['fields']
    end
  end
end
