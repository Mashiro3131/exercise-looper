# frozen_string_literal: true

require "dotenv"
require "rack"
require "rack/static"

require_relative "db/database"
require_relative "repository/questionnaire_repository"
require_relative "repository/question_repository"
require_relative "service/exercice_looper_service"
require_relative "app"

Dotenv.load(File.expand_path(".env", __dir__))

db_connection = Database.connection

questionnaire_repository = QuestionnaireRepository.new(db_connection)
question_repository = QuestionRepository.new(db_connection)

exercice_looper_service = ExerciceLooperService.new(
  questionnaire_repository,
  question_repository
)

use Rack::Static,
    urls: ["/assets"],
    root: File.expand_path("..", __dir__)

run App.new(exercice_looper_service)