# This file is used by Rack-based servers to start the application.

require ::File.expand_path('lib/clickatell/catcher/rack', __dir__)
run Clickatell::Catcher::Rack::Middleware
