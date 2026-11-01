require "rack"

require_relative "router/router"

class App
  def initialize(questionnaires_service, questions_service)
    @router = Router.new
  end

  def call(env)
    request = Rack::Request.new(env)
    @router.dispatch(request)
  end
end