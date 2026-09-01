# api.rb

require "json"
require_relative 'service/exercice_looper_service'

class Api

  def initialize
    @exercice_looper_service = ExerciceLooperService.new
  end
  def call(env)
    path = env["PATH_INFO"]
    method = env["REQUEST_METHOD"]


      if path == "/api/questionnaires" && method == "POST"
        body = env["rack.input"].read
        data = JSON.parse(body)

        title = data["title"]

        @exercice_looper_service.create_questionnaire(title)

        return [201, { "content-type" => "application/json" }, [{ message: "Questionnaire #{title} CREATED " }.to_json]]

      end
  end
end