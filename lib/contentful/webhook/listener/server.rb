require 'thread'
require 'webrick'
require 'stringio'
require 'contentful/webhook/listener/controllers'
require 'contentful/webhook/listener/support'

module Contentful
  module Webhook
    module Listener
      # Server is the responsible for handling Webhook receiver endpoints
      # Configuration defaults are:
      #   - port: 5678
      #   - address: '0.0.0.0'
      #   - logger: Contentful::Webhook::Support::NullLogger.new
      #   - endpoints: [{
      #       endpoint: '/receive',
      #       controller: Contentful::Webhook::Listener::Controllers::Wait,
      #       timeout: 300
      #     }]
      class Server
        DEFAULT_PORT = 5678
        DEFAULT_ADDRESS = '0.0.0.0'
        DEFAULT_ENDPOINTS = [
          {
            endpoint: '/receive',
            controller: Contentful::Webhook::Listener::Controllers::Wait,
            timeout: 300
          }
        ]

        def self.start(config = {})
          yield config if block_given?

          Thread.new { Server.new(config).start }
        end

        attr_reader :port, :address, :endpoints, :logger, :server

        def initialize(config = {})
          @port = config.fetch(:port, DEFAULT_PORT)
          @address = config.fetch(:address, DEFAULT_ADDRESS)
          @endpoints = config.fetch(:endpoints, DEFAULT_ENDPOINTS)
          @logger = config.fetch(
            :logger,
            Contentful::Webhook::Listener::Support::NullLogger.new
          )
        end

        def start
          logger.info "Webhook server starting at: http://#{@address}:#{@port}"

          @server = create_server
          mount_endpoints

          @server.start
        end

        protected

        def create_server
          WEBrick::HTTPServer.new(
            Port: @port,
            BindAddress: @address,
            AccessLog: [],
            Logger: Contentful::Webhook::Listener::Support::NullLogger.new
          )
        end

        def mount_endpoints
          logger.info 'Available Endpoints:'
          @endpoints.each do |endpoint_config|
            @server.mount(
              endpoint_config[:endpoint],
              endpoint_config[:controller],
              @logger,
              endpoint_config[:timeout]
            )

            log_endpoint_data(endpoint_config)
          end
        end

        def log_endpoint_data(endpoint_config)
          endpoint_data = [
            endpoint_config[:endpoint],
            "Controller: #{endpoint_config[:controller].name}",
            "Timeout: #{endpoint_config[:timeout]}"
          ]

          logger.info "\t#{endpoint_data.join(' - ')}"
        end
      end
    end
  end
end
