# api.rb

require "json"

require_relative "db/database"
require_relative "repository/questionnaire_repository"
require_relative "service/exercice_looper_service"

class Api
  def initialize
    db_connection = Database.connection
    questionnaire_repository = QuestionnaireRepository.new(db_connection)
    @exercice_looper_service = ExerciceLooperService.new(questionnaire_repository)
  end

  def call(env)
    path = env["PATH_INFO"]
    method = env["REQUEST_METHOD"]

    if path == "/api/questionnaires" && method == "POST"
      body = env["rack.input"].read
      data = JSON.parse(body)

      title = data["title"]
      @exercice_looper_service.create_questionnaire(title)

      return [201, { "content-type" => "application/json" }, [{ message: "Questionnaire #{title} created" }.to_json]]
    end

    if path == "/api/questionnaires" && method == "GET"
      questionnaires = @exercice_looper_service.fetch_all_questionnaires
      return [ 200, { "content-type" => "application/json" }, [{ questionnaires: questionnaires }.to_json]]
    end

    # NO MATCH DE ROUTE RETURN CA
    [404, { "content-type" => "application/json" }, [{ message: "Route not found" }.to_json]]
  end
end