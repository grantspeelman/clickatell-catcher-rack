require 'rack/request'

require 'clickatell/sandbox/rack/version'
require 'clickatell/sandbox/rack/message_adder'

module Clickatell
  module Sandbox
    module Rack
      class Middleware
        attr_reader :messages

        def initialize(app)
          @app = app
          @messages = []
          @message_adder = MessageAdder.new(@messages)
        end

        def add_message(request_body)
          @message_adder.add(request_body)
          @message_adder.rack_response
        end

        def render_messages
          [200,
           { 'Content-Type' => 'text/html' },
           ['<html><body><p>this is a sample 44711112222</p></body></html>']]
        end

        def rest_message(request)
          if request.get?
            render_messages
          else
            add_message(request.body.string)
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
