require 'rack/request'
require 'multi_json'

require 'clickatell/sandbox/rack/version'

module Clickatell
  module Sandbox
    module Rack
      class Middleware
        attr_reader :messages

        def initialize(app)
          @app = app
          @messages = []
        end

        def add_message(request_body)
          message = MultiJson.load(request_body)
          @messages << message
          response = { 'data' => { 'message' => [
            { 'accepted' => true, 'to' => '27711234567', 'apiMessageId' => '1' }] } }
          json_body = MultiJson.dump(response)
          [200, { 'Content-Type' => 'application/json' }, [json_body]]
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
