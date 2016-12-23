require 'spec_helper'

describe Contentful::Webhook::Listener::Controllers::WebhookAware do
  let(:server) { MockServer.new }
  let(:logger) { Contentful::Webhook::Listener::Support::NullLogger.new }
  let(:timeout) { 10 }
  let(:body) { {sys: { id: 'foo', space: { sys: { id: 'space_foo' } } }, fields: {} } }
  subject { described_class.new(server, logger, timeout) }

  describe 'event methods called for corresponding webhook event type' do
    [:publish, :unpublish, :archive, :unarchive, :save, :auto_save, :create, :delete].each do |event|
      it "calls ##{event}" do
        expect(subject).to receive(event)
        subject.respond(RequestDummy.new({'X-Contentful-Topic' => "ContentfulManagement.Entry.#{event}"}, body), MockResponse.new).join
      end
    end
  end

  it 'returns 400 Bad Request on non-webhook call' do
    response = MockResponse.new
    subject.respond(RequestDummy.new(nil, "foo"), response)

    expect(response.status).to eq(400)
    expect(response.body).to eq('Not a Webhook')
  end
end
