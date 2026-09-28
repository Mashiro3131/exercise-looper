# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"

require_relative "../../services/exercice_looper_service"

class ExerciceLooperServiceTest < Minitest::Test

  def setup
    @questionnaire_repository = Minitest::Mock.new
    @question_repository = Minitest::Mock.new
    @service = ExerciceLooperService.new(@questionnaire_repository,@question_repository)
  end

  def test_create_questionnaire
    puts "\n--- TEST create_questionnaire ---"

    @questionnaire_repository.expect(:create, 42, ["My questionnaire"])

    puts "Creating questionnaire: 'My questionnaire'"

    result = @service.create_questionnaire("My questionnaire")

    puts "Expected result: 42"
    puts "Actual result:   #{result}"

    assert_equal 42, result
    @questionnaire_repository.verify

    puts "Test IS GOOOODDDD"
  end

end