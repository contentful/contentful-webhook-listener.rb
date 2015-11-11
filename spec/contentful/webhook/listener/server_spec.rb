require 'spec_helper'

describe Contentful::Webhook::Listener::Server do
  let(:server) { Contentful::Webhook::Listener::Server.new }

  describe 'class methods' do
    describe '::start' do
      it 'spawns a brackground thread' do
        expect(Thread).to receive(:new)

        Contentful::Webhook::Listener::Server.start
      end
    end
  end

  describe 'instance methods' do
    describe "#start" do
      before do
        expect_any_instance_of(WEBrick::HTTPServer).to receive(:start)
        expect(WEBrick::Utils).to receive(:create_listeners) { [] } # Mock TCP Port binding
      end

      it "logs server messages" do
        expect(server.logger).to receive(:info).once.ordered.with("Webhook server starting at: http://#{server.address}:#{server.port}")
        expect(server.logger).to receive(:info).once.ordered.with("Available Endpoints:")
        expect(server.logger).to receive(:info).once.ordered.with("\t/receive - Controller: Contentful::Webhook::Listener::Controllers::Wait - Timeout: 300")

        server.start
      end

      it "mounts endpoints" do
        expect_any_instance_of(WEBrick::HTTPServer).to receive(:mount).with(
          "/receive",
          Contentful::Webhook::Listener::Controllers::Wait,
          Contentful::Webhook::Listener::Support::NullLogger,
          300
        )

        server.start
      end
    end
  end

  describe "defaults" do
    it ":port" do
      expect(server.port).to eq 5678
    end

    it ":address" do
      expect(server.address).to eq "0.0.0.0"
    end

    it ":endpoints" do
      expected = [
        {
          endpoint: '/receive',
          controller: Contentful::Webhook::Listener::Controllers::Wait,
          timeout: 300
        }
      ]

      expect(server.endpoints).to match_array expected
    end

    it ":logger" do
      expect(server.logger).to be_a Contentful::Webhook::Listener::Support::NullLogger
    end
  end
end
