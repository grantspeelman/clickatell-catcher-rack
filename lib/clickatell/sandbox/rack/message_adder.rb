require 'multi_json'

module Clickatell
  module Sandbox
    module Rack
      class MessageAdder
        def initialize(messages)
          @messages = messages
        end

        def add(request_body)
          message = MultiJson.load(request_body)
          @messages << message
          response = { 'data' => { 'message' => [
            { 'accepted' => true, 'to' => '27711234567', 'apiMessageId' => '1' }] } }
          @json_body = MultiJson.dump(response)
        end

        def rack_response
          [200, { 'Content-Type' => 'application/json' }, [@json_body]]
        end
      end
    end
  end
end
