require_relative "../controllers/questionnaires_controller"
require_relative "../controllers/questions_controller"
require_relative "../controllers/answers_controller"
require_relative "route"
require_relative "dynamic_route"

class Router
  def initialize
    @routes = [
      Route.new("/", "GET", QuestionnairesController, "home"),
      Route.new("/exercises", "GET", QuestionnairesController, "index"),
      Route.new("/exercises/new", "GET", QuestionnairesController, "new"),
      Route.new("/exercises", "POST", QuestionnairesController, "create"),
      DynamicRoute.new("/exercises/:id/fields", "GET", QuestionsController, "fields"),
      DynamicRoute.new("/exercises/:id/fields", "POST", QuestionsController, "create_field"),
      DynamicRoute.new("/exercises/:id", "PUT", QuestionnairesController, "update_status"),

      Route.new("/exercises/answering", "GET", AnswersController, "index"),
      DynamicRoute.new("/exercises/:id/fulfillments/new", "GET", AnswersController, "new"),
      DynamicRoute.new("/exercises/:id/fulfillments", "POST", AnswersController, "create"),
      DynamicRoute.new("/exercises/:id/fulfillments/:submission_id/edit", "GET", AnswersController, "edit"),
      DynamicRoute.new("/exercises/:id/fulfillments/:submission_id", "PUT", AnswersController, "update")
    ]
  end

  def find(request)
    puts "REQUEST METHOD: #{request.request_method}"
    puts "REQUEST PATH: #{request.path_info}"

    @routes.find do |route|
      matched = route.match?(request)
      puts "Route: #{route.inspect} => #{matched}"
      matched
    end
  end

  def dispatch(request)
    route = find(request)
    return QuestionnairesController.new(request).not_found unless route
    route.act(request)
  end
end
