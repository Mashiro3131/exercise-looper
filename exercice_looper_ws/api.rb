require "json"
require "uri"
require "rack"

class Api
  def initialize(questionnaires_service, questions_service)
    @questionnaires_service = questionnaires_service
    @questions_service = questions_service
  end

  def call(env)
    request = Rack::Request.new(env)

    path = request.path_info
    method = request.request_method

    # DOCUMENTATION RACK
    # https://rack.github.io/rack/3.2/Rack/Request/Helpers.html

    # ================== QUESTIONNAIRES ==================

    if path == "/api/questionnaires" && method == "POST"
      data = request.params
      title = data["title"]

      questionnaire_id = @questionnaires_service.create_questionnaire(title)

      response = {
        message: "Questionnaire #{title} created",
        questionnaire_id: questionnaire_id
      }

      return [
        201,
        { "content-type" => "application/json" },
        [response.to_json]
      ]
    end

    if path == "/api/questionnaires" && method == "PUT"
      data = request.params

      status = data["status"]
      id_questionnaire = data["id_questionnaire"]

      @questionnaires_service.update_questionnaire(
        id_questionnaire,
        status
      )

      return [
        201,
        { "content-type" => "application/json" },
        [
          {
            message: "Questionnaire #{id_questionnaire} UPDATE, Status is now #{status}"
          }.to_json
        ]
      ]
    end

    if path == "/api/questionnaires" && method == "GET"
      questionnaires = @questionnaires_service.fetch_all_questionnaires

      return [
        200,
        { "content-type" => "application/json" },
        [{ questionnaires: questionnaires }.to_json]
      ]
    end

    if method == "GET" && (match = path.match(%r{\A/api/questionnaires/(\d+)\z}))
      questionnaire_id = match[1]

      questionnaire =
        @questionnaires_service.fetch_questionnaire_by_questionnaire_id(
          questionnaire_id
        )

      if questionnaire.nil?
        return [
          404,
          { "content-type" => "application/json" },
          [{ error: "Questionnaire not found" }.to_json]
        ]
      end

      return [
        200,
        { "content-type" => "application/json" },
        [questionnaire.to_json]
      ]
    end

    # ================== QUESTIONS ==================

    if method == "GET" && (match = path.match(%r{\A/api/questions/(\d+)\z}))
      questionnaire_id = match[1]

      questions =
        @questions_service.find_all_questions_by_questionnaire_id(
          questionnaire_id
        )

      return [
        200,
        { "content-type" => "application/json" },
        [{ questions: questions }.to_json]
      ]
    end

    if path == "/api/questions" && method == "POST"
      body = env["rack.input"].read
      data = JSON.parse(body)

      questionnaire_id = data["questionnaire_id"]
      question_text = data["question_text"]
      question_type_id = data["question_type_id"]

      @questions_service.create_question(
        question_text,
        questionnaire_id,
        question_type_id
      )

      return [
        201,
        { "content-type" => "application/json" },
        [{ message: "question #{question_text} created" }.to_json]
      ]
    end

    if path == "/api/questions" && method == "PUT"
      body = env["rack.input"].read
      data = JSON.parse(body)

      question_id = data["question_id"]
      questionnaire_id = data["questionnaire_id"]
      question_text = data["question_text"]
      question_type_id = data["question_type_id"]

      @questions_service.update_question(
        question_id,
        question_text,
        questionnaire_id,
        question_type_id
      )

      return [
        200,
        { "content-type" => "application/json" },
        [{ message: "question #{question_text} UPDATED" }.to_json]
      ]
    end

    # NO MATCH DE ROUTE RETURN CA
    [
      404,
      { "content-type" => "application/json" },
      [{ message: "Route not found" }.to_json]
    ]
  end
end