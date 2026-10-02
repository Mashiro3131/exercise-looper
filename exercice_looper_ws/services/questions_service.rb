# frozen_string_literal: true

class QuestionsService
  QUESTION_TYPE_DESCRIPTIONS = {
    "single_line" => "Single line text",
    "single_line_list" => "List of single lines",
    "multi_line" => "Multi-line text",
  }.freeze

  def initialize(questions_repository)
    @questions_repository = questions_repository
  end

  def create_question(question_text, questionnaire_id, question_type_id)
    @questions_repository.create(question_text, questionnaire_id, question_type_id)
  end

  def create_question_from_value_kind(question_text, questionnaire_id, value_kind)
    question_text = question_text.to_s.strip

    if question_text.empty?
      raise ArgumentError, "Question label is required"
    end

    description = QUESTION_TYPE_DESCRIPTIONS[value_kind]

    if description.nil?
      raise ArgumentError, "Unknown question type"
    end

    question_type_id = @questions_repository.find_question_type_id_by_description(description)

    if question_type_id.nil?
      raise ArgumentError, "Question type is missing from the database"
    end

    @questions_repository.create(question_text, questionnaire_id, question_type_id)
  end

  def update_question(question_id,question_text, questionnaire_id, question_type_id)
    @questions_repository.update(question_id,question_text, questionnaire_id, question_type_id)
  end

  def find_all_questions_by_questionnaire_id(questionnaire_id)
    @questions_repository.find_all_questions_by_questionnaire_id(questionnaire_id)
  end

end
