require 'spec_helper'

describe Contentful::Webhook::Listener::Controllers::Base do
  let(:server) { MockServer.new }
  let(:logger) { Contentful::Webhook::Listener::Support::NullLogger.new }
  let(:base) { Contentful::Webhook::Listener::Controllers::Base.new server, logger }

  describe "instance methods" do
    [:do_GET, :do_POST, :respond].each do |name|
      it "##{name} spawn a background job" do
        expect(Thread).to receive(:new)

        base.send(name, MockRequest.new, MockResponse.new)
      end
    end
  end
end
