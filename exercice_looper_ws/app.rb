require "rack"

require_relative "api"
require_relative "router/router"

class App
  def initialize(questionnaires_service, questions_service)
    @api = Api.new(questionnaires_service, questions_service)
    @router = Router.new
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.path_info.start_with?("/api/")
      return @api.call(env)
    end

    @router.dispatch(request)
  end
end