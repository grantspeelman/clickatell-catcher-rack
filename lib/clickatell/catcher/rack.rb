require 'rack'

require 'clickatell/catcher/rack/version'
require 'clickatell/catcher/rack/message_adder'
require 'clickatell/catcher/rack/messages_renderer'
require 'clickatell/catcher/rack/shared_array'

module Clickatell
  module Catcher
    module Rack
      class Middleware
        attr_reader :messages

        def initialize(app, options = {})
          @app = app
          @messages = Clickatell::Catcher::Rack::SharedArray.new
          @logger = options[:logger] || ::Rack::NullLogger.new(nil)
          @message_adder = MessageAdder.new(@messages)
          @messages_renderer = MessagesRenderer.new(@messages)
        end

        def add_message(request_body)
          @message_adder.add(request_body)
          @logger.debug("[#{Process.pid}] Messages: " + @messages.inspect)
          @message_adder.rack_response
        end

        def render_messages
          @logger.debug("[#{Process.pid}] Rendering Messages: " + @messages.inspect)
          @messages_renderer.rack_response
        end

        def rest_message(request)
          if request.get?
            render_messages
          else
            add_message(request.body.read)
          end
        end

        def call(env)
          request = ::Rack::Request.new(env)
          if request.path == '/rest/message'
            rest_message(request)
          else
            status, headers, body = @app.call(env)

            # return result
            [status, headers, body]
          end
        end
      end
    end
  end
end
