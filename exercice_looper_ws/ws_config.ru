require "dotenv/load"
require_relative "api"

class SafeStatic
  def initialize(app)
    @app = app
    @file_server = Rack::Static.new(
      app,
      urls: [""],
      root: File.expand_path("..", __dir__),
      index: "index.html"
    )
  end

  def call(env)
    path = env["PATH_INFO"]

    if env["REQUEST_METHOD"] == "GET" && (path == "/" || path == "/index.html" || path == "/exercises.html")
      return @app.call(env)
    end

    return @app.call(env) unless env["REQUEST_METHOD"] == "GET"

    @file_server.call(env)
  end
end

use SafeStatic
run Api.new