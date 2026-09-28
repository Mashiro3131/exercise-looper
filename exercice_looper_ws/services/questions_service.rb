# frozen_string_literal: true

class QuestionsService

  def initialize(questions_repository)
    @questions_repository = questions_repository
  end

  def create_question(question_text, questionnaire_id, question_type_id)
    @questions_repository.create(question_text, questionnaire_id, question_type_id)
  end

  def update_question(question_id,question_text, questionnaire_id, question_type_id)
    @questions_repository.update(question_id,question_text, questionnaire_id, question_type_id)
  end

  def find_all_questions_by_questionnaire_id(questionnaire_id)
    @questions_repository.find_all_questions_by_questionnaire_id(questionnaire_id)
  end

end
