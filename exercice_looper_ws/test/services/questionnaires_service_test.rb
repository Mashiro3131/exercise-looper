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

    @questionnaire_repository.expect(
      :create, questionnaire, ["My questionnaire"]
    )

    created_questionnaire = @service.create_questionnaire("My questionnaire")

    puts "Created:"
    puts created_questionnaire

    assert_equal "editing", created_questionnaire["status"]

    @questionnaire_repository.expect(:update, true, [42, "closed"])

    result = @service.update_questionnaire(
      created_questionnaire["id"], "closed"
    )

    puts "Expected result: true"
    puts "Actual result:   #{result}"

    assert_equal true, result
    @questionnaire_repository.verify

    puts "Test IS GOOOODDDD"
  end

  def test_fetch_all_questionnaires
    puts "######### TEST fetch_all_questionnaires #############"

    questionnaires = [
      { "id" => 42, "title" => "My questionnaire", "status" => "editing" },
      { "id" => 43, "title" => "Another questionnaire", "status" => "closed" }
    ]

    @questionnaire_repository.expect(:find_all, questionnaires, [])

    result = @service.fetch_all_questionnaires

    puts "Expected result: #{questionnaires}"
    puts "Actual result:   #{result}"

    assert_equal questionnaires, result
    @questionnaire_repository.verify

    puts "Test IS GOOOODDDD"
  end

  def test_fetch_questionnaire_by_questionnaire_id
    puts "######### TEST fetch_questionnaire_by_questionnaire_id #############"

    questionnaire = {
      "id" => 42,
      "title" => "My questionnaire",
      "status" => "editing"
    }

    @questionnaire_repository.expect(:find_by_id, questionnaire, [42])

    result = @service.fetch_questionnaire_by_questionnaire_id(42)

    puts "Expected result: #{questionnaire}"
    puts "Actual result:   #{result}"

    assert_equal questionnaire, result
    @questionnaire_repository.verify

    puts "Test IS GOOOODDDD"
  end
end