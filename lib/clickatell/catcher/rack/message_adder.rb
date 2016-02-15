require 'multi_json'

module Clickatell
  module Catcher
    module Rack
      class MessageAdder
        def initialize(messages)
          @messages = messages
          @message_id = 1
        end

        def add(request_body)
          message = MultiJson.load(request_body)
          @messages << message.merge('added_at' => Time.now)
          response = { 'data' => { 'message' => build_messages_response(message) } }
          @json_body = MultiJson.dump(response)
        end

        def rack_response
          [200, { 'Content-Type' => 'application/json' }, [@json_body]]
        end

        private

        def build_messages_response(message)
          start_index = @message_id
          @message_id += message['to'].size
          message['to'].map.with_index(start_index) do |to, i|
            { 'accepted' => true, 'to' => to, 'apiMessageId' => i.to_s }
          end
        end
      end
    end
  end
end
