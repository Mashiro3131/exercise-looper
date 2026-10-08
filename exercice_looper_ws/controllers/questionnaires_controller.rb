# frozen_string_literal: true

require_relative "base_controller"
require_relative "../db/database"
require_relative "../repository/questionnaire_repository"
require_relative "../repository/question_repository"
require_relative "../services/questionnaires_service"
require_relative "../services/questions_service"

class QuestionnairesController < BaseController
  def initialize(request)
    @request = request
    db_connection = Database.connection
    @questionnaires_service = QuestionnairesService.new(QuestionnaireRepository.new(db_connection))
    @questions_service = QuestionsService.new(QuestionRepository.new(db_connection))
  end

  def not_found
    view("404", code: 404)
  end

  def home
    view("index")
  end

  def index
    questionnaires = @questionnaires_service.fetch_all_questionnaires
    questionnaires = questionnaires.map { |questionnaire| questionnaire.transform_keys(&:to_s) }

    view("exercises/index", data: { questionnaires: questionnaires })
  end

  def new
    view("exercises/new")
  end

  def create
    title = @request.params["exercise"]["title"]
    questionnaire_id = @questionnaires_service.create_questionnaire(title)

    redirect("/exercises/#{questionnaire_id}/fields")
  end

  def update_status
    status = @request.params["exercise"]["status"]
    questionnaire_id = current_questionnaire_id

    if status == "answering"
      questions = @questions_service.find_all_questions_by_questionnaire_id(questionnaire_id)
      return redirect("/exercises/#{questionnaire_id}/fields") if questions.empty?
    end

    @questionnaires_service.update_questionnaire(questionnaire_id, status)
    redirect("/exercises")
  end

  def current_questionnaire_id
    @request.path_info.split("/")[2]
  end
end