require "minitest/autorun"
require "minitest/mock"

require_relative "../../services/questionnaires_service"


class QuestionnairesServiceTest < Minitest::Test

  def setup
    @questionnaire_repository = Minitest::Mock.new
    @service = QuestionnairesService.new(@questionnaire_repository)
  end

  def test_create_questionnaire
    puts "######### TEST create_questionnaire #############"

    @questionnaire_repository.expect(:create, 42, ["My questionnaire"])

    puts "Creating questionnaire: 'My questionnaire'"

    result = @service.create_questionnaire("My questionnaire")

    puts "Expected result: 42"
    puts "Actual result:   #{result}"

    assert_equal 42, result
    @questionnaire_repository.verify

    puts "Test IS GOOOODDDD"
  end


  def test_update_questionnaire
    puts "####### TEST create + update questionnaire #########"

    questionnaire = {
      "id" => 42,
      "title" => "My questionnaire",
      "status" => "editing"
    }

    @questionnaire_repository.expect(:create, questionnaire, ["My questionnaire"])

    created_questionnaire = @service.create_questionnaire("My questionnaire")

    puts "Created:"
    puts created_questionnaire

    assert_equal "editing", created_questionnaire["status"]

    @questionnaire_repository.expect(:update, true, [42, "closed"])

    updated_questionnaire = @service.update_questionnaire(created_questionnaire["id"], "closed")

    puts "Updated:"
    puts updated_questionnaire

    @questionnaire_repository.verify
  end

end

