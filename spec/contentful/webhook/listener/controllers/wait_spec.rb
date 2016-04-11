require 'spec_helper'

describe Contentful::Webhook::Listener::Controllers::Wait do
  let(:server) { MockServer.new }
  let(:logger) { Contentful::Webhook::Listener::Support::NullLogger.new }
  let(:timeout) { 10 }
  let(:wait) { Contentful::Webhook::Listener::Controllers::Wait.new server, logger, timeout }

  describe "instance methods" do
    [:do_GET, :do_POST, :respond].each do |name|
      it "##{name} spawn a background job" do
        expect(Thread).to receive(:new)

        wait.send(name, MockRequest.new, MockResponse.new)
      end

      # This spec requires to read/erase a Class Variable
      # because RSpec doesn't know how to test within spawned Threads
      it "##{name} wait on background" do
        wait.send(name, MockRequest.new, MockResponse.new).join

        expect(wait.class.sleeping).to be_truthy
      end
    end
  end
end
