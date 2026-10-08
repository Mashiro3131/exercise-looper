# frozen_string_literal: true

require_relative "base_controller"
require_relative "../db/database"
require_relative "../repository/questionnaire_repository"
require_relative "../repository/question_repository"
require_relative "../services/questionnaires_service"
require_relative "../services/questions_service"

class QuestionsController < BaseController
  def initialize(request)
    @request = request


    db_connection = Database.connection
    @questionnaires_service = QuestionnairesService.new(QuestionnaireRepository.new(db_connection))
    @questions_service = QuestionsService.new(QuestionRepository.new(db_connection))
  end

  def fields
    questionnaire_id = current_questionnaire_id
    puts "[QuestionsController#fields] id=#{questionnaire_id.inspect}"

    questionnaire = @questionnaires_service.fetch_questionnaire_by_questionnaire_id(questionnaire_id)
    puts "[QuestionsController#fields] found=#{!questionnaire.nil?}"

    return view("404", code: 404) unless questionnaire

    questionnaire = questionnaire.transform_keys(&:to_s)
    questions = @questions_service.find_all_questions_by_questionnaire_id(questionnaire_id)
                                  .map { |question| question.transform_keys(&:to_s) }

    view("exercises/fields", data: { questionnaire: questionnaire, questions: questions })
  end

  def create_field
    questionnaire_id = current_questionnaire_id
    questionnaire = @questionnaires_service.fetch_questionnaire_by_questionnaire_id(questionnaire_id)

    return [404, { "content-type" => "text/plain" }, ["Questionnaire not found"]] unless questionnaire

    field = @request.params["field"]
    question_text = field["label"].to_s.strip
    value_kind = field["value_kind"].to_s

    begin
      @questions_service.create_question_from_value_kind(question_text, questionnaire_id, value_kind)
    rescue ArgumentError => e
      return [422, { "content-type" => "text/plain" }, [e.message]]
    end

    redirect("/exercises/#{questionnaire_id}/fields")
  end

  def current_questionnaire_id
    @request.path_info.split("/")[2]
  end
end