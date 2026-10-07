require "minitest/autorun"
require "minitest/mock"

require_relative "../../services/questions_service"

class QuestionsServiceTest < Minitest::Test
  def setup
    @questions_repository = Minitest::Mock.new
    @service = QuestionsService.new(@questions_repository)
  end

  def test_create_question
    puts "######### TEST create_question #############"

    @questions_repository.expect(:create, 10, ["Your name?", 42, 1])

    result = @service.create_question("Your name?", 42, 1)

    puts "Expected result: 10"
    puts "Actual result:   #{result}"

    assert_equal 10, result
    @questions_repository.verify

    puts "Test IS GOOOODDDD"
  end

  def test_update_question
    puts "######### TEST update_question #############"

    @questions_repository.expect(
      :update, true, [10, "Your full name?", 42, 1]
    )

    result = @service.update_question(10, "Your full name?", 42, 1)

    puts "Expected result: true"
    puts "Actual result:   #{result}"

    assert_equal true, result
    @questions_repository.verify

    puts "Test IS GOOOODDDD"
  end

  def test_find_all_questions_by_questionnaire_id
    puts "######### TEST find_all_questions_by_questionnaire_id #############"

    questions = [
      {
        "question_id" => 10,
        "question_text" => "Your name?",
        "questionnaire_id" => 42,
        "question_type_id" => 1
      },
      {
        "question_id" => 11,
        "question_text" => "Your description?",
        "questionnaire_id" => 42,
        "question_type_id" => 3
      }
    ]

    @questions_repository.expect(
      :find_all_questions_by_questionnaire_id, questions, [42]
    )

    result = @service.find_all_questions_by_questionnaire_id(42)

    puts "Expected result: #{questions}"
    puts "Actual result:   #{result}"

    assert_equal questions, result
    @questions_repository.verify

    puts "Test IS GOOOODDDD"
  end

  def test_create_question_from_value_kind
    puts "######### TEST create_question_from_value_kind #############"

    types = [
      ["single_line", "Single line text", 1],
      ["single_line_list", "List of single lines", 2],
      ["multi_line", "Multi-line text", 3]
    ]

    types.each do |value_kind, description, type_id|
      @questions_repository.expect(
        :find_question_type_id_by_description, type_id, [description]
      )

      @questions_repository.expect(
        :create, 10, ["Your answer?", 42, type_id]
      )

      result = @service.create_question_from_value_kind(
        "Your answer?", 42, value_kind
      )

      puts "Question type:   #{value_kind}"
      puts "Expected result: 10"
      puts "Actual result:   #{result}"

      assert_equal 10, result
    end

    @questions_repository.verify

    puts "Test IS GOOOODDDD"
  end

  def test_create_question_from_value_kind_strips_spaces
    puts "######### TEST question label spaces #############"

    @questions_repository.expect(
      :find_question_type_id_by_description, 1, ["Single line text"]
    )

    @questions_repository.expect(:create, 10, ["Your name?", 42, 1])

    result = @service.create_question_from_value_kind(
      "  Your name?  ", 42, "single_line"
    )

    assert_equal 10, result
    @questions_repository.verify

    puts "Test IS GOOOODDDD"
  end

  def test_create_question_from_value_kind_with_empty_label
    puts "######### TEST empty question label #############"

    ["", "   ", nil].each do |label|
      error = assert_raises(ArgumentError) do
        @service.create_question_from_value_kind(label, 42, "single_line")
      end

      puts "Actual error: #{error.message}"

      assert_equal "Question label is required", error.message
    end

    @questions_repository.verify

    puts "Test IS GOOOODDDD"
  end

  def test_create_question_from_value_kind_with_unknown_type
    puts "######### TEST unknown question type #############"

    error = assert_raises(ArgumentError) do
      @service.create_question_from_value_kind(
        "Your name?", 42, "unknown_type"
      )
    end

    puts "Actual error: #{error.message}"

    assert_equal "Unknown question type", error.message
    @questions_repository.verify

    puts "Test IS GOOOODDDD"
  end

  def test_create_question_from_value_kind_with_missing_database_type
    puts "######### TEST missing database question type #############"

    @questions_repository.expect(
      :find_question_type_id_by_description, nil, ["Single line text"]
    )

    error = assert_raises(ArgumentError) do
      @service.create_question_from_value_kind(
        "Your name?", 42, "single_line"
      )
    end

    puts "Actual error: #{error.message}"

    assert_equal(
      "Question type is missing from the database",
      error.message
    )

    @questions_repository.verify

    puts "Test IS GOOOODDDD"
  end
end