# frozen_string_literal: true

require "rack"

require_relative "api"
require_relative "controllers/exercises_controller"

class App
  def initialize(exercice_looper_service)
    @api = Api.new(exercice_looper_service)
    @exercises_controller = ExercisesController.new(exercice_looper_service)
  end

  def call(env)
    request = Rack::Request.new(env)

    path = request.path_info
    method = request.request_method

    if path.start_with?("/api/")
      return @api.call(env)
    end

    if path == "/" && method == "GET"
      return @exercises_controller.home
    end

    if path == "/exercises/new" && method == "GET"
      return @exercises_controller.new
    end

    if path == "/exercises" && method == "POST"
      return @exercises_controller.create(request)
    end

    if path == "/exercises" && method == "GET"
      return @exercises_controller.index
    end

    if method == "GET" && (match = path.match(%r{\A/exercises/(\d+)/fields\z}))
      questionnaire_id = match[1]

      return @exercises_controller.fields(questionnaire_id)
    end

    return @exercises_controller.not_found
  end
end