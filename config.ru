# This file is used by Rack-based servers to start the application.

require ::File.expand_path('lib/clickatell/sandbox/rack', __dir__)
run Clickatell::Sandbox::Rack::Middleware
