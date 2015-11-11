require 'spec_helper'

describe Contentful::Webhook::Listener::Support::NullLogger do
  let(:logger) { Contentful::Webhook::Listener::Support::NullLogger.new }

  describe "instance methods" do
    [:info, :debug, :warn, :error, :write].each do |name|
      it "##{name} returns nil" do
        expect(logger.send(name, "foo")).to eq nil
      end

      it "##{name} doesn't output to STDOUT" do
        expect { logger.send(name, "foo") }.to_not output("foo").to_stdout
      end
    end
  end
end
