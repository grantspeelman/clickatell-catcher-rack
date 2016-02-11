require 'multi_json'
require 'erb'

module Clickatell
  module Sandbox
    module Rack
      class MessagesRenderer
        def initialize(messages)
          @messages = messages
          @renderer = ERB.new(File.read(__dir__ + "/messages.html.erb"))
        end

        def rack_response
          [200,
           { 'Content-Type' => 'text/html' },
           [render_content]]
        end

        private

        def render_content
          @renderer.result(binding)
        end
      end
    end
  end
end
