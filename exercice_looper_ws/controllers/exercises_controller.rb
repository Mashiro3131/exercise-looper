# frozen_string_literal: true

require_relative "base_controller"

class ExercisesController < BaseController
  def initialize(questionnaires_service, questions_service)
    @questionnaires_service = questionnaires_service
    @questions_service = questions_service
  end

  def not_found
    view("404", code: 404)
  end

  def home
    view("index")
  end

  def index
    questionnaires = @questionnaires_service.fetch_all_questionnaires

    questionnaires = questionnaires.map do |questionnaire|
      questionnaire.transform_keys(&:to_s)
    end

    view(
      "exercises/index",
      data: {
        questionnaires: questionnaires
      }
    )
  end

  def new
    view("exercises/new")
  end

  def create(request)
    title = request.params["exercise"]["title"]

    questionnaire_id = @questionnaires_service.create_questionnaire(title)

    redirect("/exercises/#{questionnaire_id}/fields")
  end

  def fields(questionnaire_id)
    questionnaire = @questionnaires_service.fetch_questionnaire_by_questionnaire_id(questionnaire_id)

    return view("404", code: 404) unless questionnaire

    questionnaire = questionnaire.transform_keys(&:to_s)

    questions = @questions_service
        .find_all_questions_by_questionnaire_id(questionnaire_id)
        .map do |question|
        question.transform_keys(&:to_s)
      end

    view("exercises/fields",
      data: { questionnaire: questionnaire, questions: questions }
    )
  end

  def create_field(request, questionnaire_id)
    questionnaire = @questionnaires_service.fetch_questionnaire_by_questionnaire_id(questionnaire_id)

    if questionnaire.nil?
      return [404, { "content-type" => "text/plain" }, ["Questionnaire not found"]]
    end

    field = request.params["field"] || {}

    question_text = field["label"].to_s.strip
    value_kind = field["value_kind"].to_s

    begin
      @questions_service.create_question_from_value_kind(
        question_text,
        questionnaire_id,
        value_kind
      )
    rescue ArgumentError => e
      return [422, { "content-type" => "text/plain" }, [e.message]]
    end

    redirect("/exercises/#{questionnaire_id}/fields")
  end

  def update_status(request, questionnaire_id)
    status = request.params["exercise"]["status"]

    if status == "answering"
      questions =
        @questions_service.find_all_questions_by_questionnaire_id(questionnaire_id)

      if questions.empty?
        return redirect(
          "/exercises/#{questionnaire_id}/fields"
        )
      end
    end

    @questionnaires_service.update_questionnaire(
      questionnaire_id,
      status
    )

    redirect("/exercises")
  end
end