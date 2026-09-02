# api.rb

require "json"

require_relative "db/database"
require_relative "repository/questionnaire_repository"
require_relative "repository/question_repository"
require_relative "service/exercice_looper_service"

class Api
  def initialize
    db_connection = Database.connection
    questionnaire_repository = QuestionnaireRepository.new(db_connection)
    question_repository = QuestionRepository.new(db_connection)
    @exercice_looper_service = ExerciceLooperService.new(questionnaire_repository, question_repository)
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

    if path == "/api/questionnaires" && method == "PUT"
      body = env["rack.input"].read
      data = JSON.parse(body)

      status = data["status"]
      id_questionnaire = data["id_questionnaire"]
      @exercice_looper_service.update_questionnaire(id_questionnaire,status)
      return [201, { "content-type" => "application/json" }, [{ message: "Questionnaire #{id_questionnaire} UPDATE, Status is now #{status}" }.to_json]]
    end

    if path == "/api/questionnaires" && method == "GET"
      questionnaires = @exercice_looper_service.fetch_all_questionnaires
      return [ 200, { "content-type" => "application/json" }, [{ questionnaires: questionnaires }.to_json]]
    end

    # QUESTIONS

    if path == "/api/questions" && method == "GET"
      body = env["rack.input"].read
      data = JSON.parse(body)

      questionnaire_id = data["questionnaire_id"]
      questions = @exercice_looper_service.find_all_questions_by_questionnaire_id(questionnaire_id)
      return [200,{ "content-type" => "application/json" }, [{questions: questions}.to_json] ]
    end

    if path == "/api/questions" && method == "POST"
      body = env["rack.input"].read
      data = JSON.parse(body)

      questionnaire_id = data["questionnaire_id"]
      question_text = data["question_text"]
      question_type_id = data["question_type_id"]

      @exercice_looper_service.create_question(question_text,questionnaire_id,question_type_id)
      return [201, { "content-type" => "application/json" }, [{ message: "question #{question_text} created" }.to_json]]
    end

    if path == "/api/questions" && method == "PUT"
      body = env["rack.input"].read
      data = JSON.parse(body)

      question_id = data["question_id"]
      questionnaire_id = data["questionnaire_id"]
      question_text = data["question_text"]
      question_type_id = data["question_type_id"]

      @exercice_looper_service.update_question(question_id,question_text,questionnaire_id,question_type_id)
      return [200, { "content-type" => "application/json" }, [{ message: "question #{question_text} UPDATED" }.to_json]]
    end

    # NO MATCH DE ROUTE RETURN CA
    [404, { "content-type" => "application/json" }, [{ message: "Route not found" }.to_json]]
  end
end