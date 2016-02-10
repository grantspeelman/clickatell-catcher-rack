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
          [200, {'Content-Type' => 'application/json'}, [json_body]]
        end

        def call(env)
          request = ::Rack::Request.new(env)
          if request.path == '/rest/message'

            add_message(request.body.string)
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
