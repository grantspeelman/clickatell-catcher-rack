require 'rack/request'

require 'clickatell/sandbox/rack/version'

module Clickatell
  module Sandbox
    module Rack
      class Middleware

        def initialize(app)
          @app = app
        end

        def call(env)
          request = ::Rack::Request.new(env)
          if request.path == '/rest/message'

            [200, {}, []]
          else
            status, headers, body  = @app.call(env)

            # return result
            [status, headers, body]
          end
        end
      end
    end
  end
end
