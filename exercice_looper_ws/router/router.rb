require_relative "../controllers/questionnaires_controller"
require_relative "../controllers/questions_controller"

class Router
  def initialize
    @routes = [
      { path: "/", method: "GET", controller: QuestionnairesController, action: :home },
      { path: "/exercises", method: "GET", controller: QuestionnairesController, action: :index },
      { path: "/exercises/new", method: "GET", controller: QuestionnairesController, action: :new },
      { path: "/exercises", method: "POST", controller: QuestionnairesController, action: :create },
      { path: %r{\A/exercises/[^/]+/fields\z}, method: "GET", controller: QuestionsController, action: :fields },
      { path: %r{\A/exercises/[^/]+/fields\z}, method: "POST", controller: QuestionsController, action: :create_field },
      { path: %r{\A/exercises/[^/]+\z}, method: "PUT", controller: QuestionnairesController, action: :update_status }
    ]
  end

  def find(request)
    warn "[Router] request method=#{request.request_method.inspect} path=#{request.path_info.inspect}"

    @routes.each do |route|
      method_match = route[:method] == request.request_method
      path_match = route[:path] === request.path_info
      return route if method_match && path_match
    end

    warn "[Router] no route matched"
    nil
  end

  def redirect(route, request)
    return QuestionnairesController.new(request).not_found unless route

    controller = route[:controller].new(request)
    controller.public_send(route[:action])
  end

  def dispatch(request)
    route = find(request)
    redirect(route, request)
  end
end