require 'thread'
require 'webrick'
require 'stringio'
require "contentful/webhook/listener/controllers/base"

module Contentful
  module Webhook
    module Listener
      class Server
        DEFAULT_PORT = 5678
        DEFAULT_ADDRESS = "0.0.0.0"
        DEFAULT_ENDPOINTS = [
          {
            endpoint: "/receive",
            controller: Contentful::Webhook::Listener::Controllers::Base,
            timeout: 300
          }
        ]

        def self.start(config = {})
          yield config if block_given?

          Thread.new { Server.new(config).start }
        end

        attr_reader :port, :address, :endpoints, :logger

        def initialize(config = {})
          @port = config.fetch(:port, DEFAULT_PORT)
          @address = config.fetch(:address, DEFAULT_ADDRESS)
          @endpoints = config.fetch(:endpoints, DEFAULT_ENDPOINTS)
          @logger = config.fetch(:logger, Contentful::Webhook::Listener::Support::NullLogger.new)
        end

        def start
          @server = WEBrick::HTTPServer.new(:Port => @port, :BindAddress => @address, :AccessLog => [], :Logger => @logger)

          logger.info "Webhook server starting at: http://#{@address}:#{@port}"
          logger.info "Available Endpoints:"
          @endpoints.each do |endpoint_config|
            @server.mount endpoint_config[:endpoint], endpoint_config[:controller], endpoint_config[:timeout]

            logger.info "\t#{endpoint_config[:endpoint]} - Controller: #{endpoint_config[:controller].name} - Timeout: #{endpoint_config[:timeout]}"
          end

          @server.start
        end
      end
    end
  end
end
