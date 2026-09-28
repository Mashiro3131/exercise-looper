# frozen_string_literal: true

require "erb"

class ExercisesController
  def initialize(exercice_looper_service)
    @exercice_looper_service = exercice_looper_service
  end

  def home
    file_path = File.expand_path("../views/index.erb", __dir__)
    html = File.read(file_path, encoding: "UTF-8")
    rendered_html = ERB.new(html).result

    return [200, { "content-type" => "text/html; charset=utf-8" }, [rendered_html]]
  end

  def index
    questionnaires = @exercice_looper_service.fetch_all_questionnaires
    questionnaires = questionnaires.map { |questionnaire| questionnaire.transform_keys(&:to_s) }

    file_path = File.expand_path("../views/exercises/index.erb", __dir__)
    html = File.read(file_path, encoding: "UTF-8")
    rendered_html = ERB.new(html).result_with_hash(questionnaires: questionnaires)

    return [200, { "content-type" => "text/html; charset=utf-8" }, [rendered_html]]
  end

  def new
    file_path = File.expand_path("../views/exercises/new.erb", __dir__)
    html = File.read(file_path, encoding: "UTF-8")
    rendered_html = ERB.new(html).result

    return [200, { "content-type" => "text/html; charset=utf-8" }, [rendered_html]]
  end

  def create(request)
    data = request.params
    title = data["exercise"]["title"]

    questionnaire_id = @exercice_looper_service.create_questionnaire(title)

    return [303, { "location" => "/exercises/#{questionnaire_id}/fields" }, []]
  end

  def not_found
    file_path = File.expand_path("../views/404.erb", __dir__)
    html = File.read(file_path, encoding: "UTF-8")
    rendered_html = ERB.new(html).result

    return [404, { "content-type" => "text/html; charset=utf-8" }, [rendered_html]]
  end

  def fields(questionnaire_id)
    questionnaire = @exercice_looper_service.fetch_questionnaire_by_questionnaire_id(questionnaire_id)

    if questionnaire.nil?
      return [404, { "content-type" => "text/plain" }, ["Questionnaire not found"]]
    end

    questionnaire = questionnaire.transform_keys(&:to_s)

    questions = @exercice_looper_service.find_all_questions_by_questionnaire_id(questionnaire_id)
    questions = questions.map { |question| question.transform_keys(&:to_s) }

    file_path = File.expand_path("../views/exercises/fields.erb", __dir__)
    html = File.read(file_path, encoding: "UTF-8")
    rendered_html = ERB.new(html).result_with_hash(
      questionnaire: questionnaire,
      questions: questions
    )

    return [200, { "content-type" => "text/html; charset=utf-8" }, [rendered_html]]
  end
end