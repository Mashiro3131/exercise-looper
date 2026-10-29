require_relative "base_controller"
require_relative "../db/database"
require_relative "../repository/questionnaire_repository"
require_relative "../repository/question_repository"
require_relative "../repository/answer_repository"
require_relative "../services/questionnaires_service"
require_relative "../services/questions_service"
require_relative "../services/answers_service"

class AnswersController < BaseController
  def initialize(request)
    @request = request
    db_connection = Database.connection

    @questionnaires_service = QuestionnairesService.new(
      QuestionnaireRepository.new(db_connection)
    )

    @questions_service = QuestionsService.new(
      QuestionRepository.new(db_connection)
    )

    @answers_service = AnswersService.new(
      AnswerRepository.new(db_connection)
    )
  end

  def index
    questionnaires = @questionnaires_service.fetch_all_questionnaires
    questionnaires = questionnaires.select do |questionnaire|
      questionnaire["status"] == "answering"
    end

    view("exercises/answering", data: {
      questionnaires: questionnaires
    })
  end

  def new
    questionnaire = answering_questionnaire
    return view("404", code: 404) unless questionnaire

    questions = questionnaire_questions
    return view("404", code: 404) if questions.empty?

    view("exercises/fulfillments/form", data: {
      questionnaire: questionnaire,
      questions: questions,
      answers: {},
      form_action: "/exercises/#{questionnaire_id}/fulfillments",
      editing: false
    })
  end

  def create
    questionnaire = answering_questionnaire
    return view("404", code: 404) unless questionnaire

    questions = questionnaire_questions
    return view("404", code: 404) if questions.empty?

    answers = @request.params["answers"] || {}
    submission_id = @answers_service.create_submission(questions, answers)

    redirect("/exercises/#{questionnaire_id}/fulfillments/#{submission_id}/edit")
  rescue ArgumentError
    [400, { "content-type" => "text/plain" }, ["Invalid answers"]]
  end

  def edit
    questionnaire = answering_questionnaire
    return view("404", code: 404) unless questionnaire

    saved_answers = @answers_service.find_answers(questionnaire_id, submission_id)
    return view("404", code: 404) if saved_answers.empty?

    answers = saved_answers.each_with_object({}) do |answer, result|
      result[answer["question_id"].to_s] = answer["answer_text"]
    end

    view("exercises/fulfillments/form", data: {
      questionnaire: questionnaire,
      questions: questionnaire_questions,
      answers: answers,
      form_action: "/exercises/#{questionnaire_id}/fulfillments/#{submission_id}",
      editing: true
    })
  end

  def update
    questionnaire = answering_questionnaire
    return view("404", code: 404) unless questionnaire

    saved_answers = @answers_service.find_answers(questionnaire_id, submission_id)
    return view("404", code: 404) if saved_answers.empty?

    answers = @request.params["answers"] || {}
    @answers_service.update_submission(submission_id, questionnaire_questions, answers)

    redirect("/exercises/#{questionnaire_id}/fulfillments/#{submission_id}/edit")
  rescue ArgumentError
    [400, { "content-type" => "text/plain" }, ["Invalid answers"]]
  end

  private

  def questionnaire_id
    @request.path_info.split("/")[2]
  end

  def submission_id
    @request.path_info.split("/")[4]
  end

  def answering_questionnaire
    questionnaire = @questionnaires_service.fetch_questionnaire_by_questionnaire_id(questionnaire_id)
    questionnaire if questionnaire && questionnaire["status"] == "answering"
  end

  def questionnaire_questions
    @questions_service.find_all_questions_by_questionnaire_id(questionnaire_id)
  end
end
