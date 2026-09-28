# frozen_string_literal: true

class QuestionRepository

  def initialize(db_connection)
    @db = db_connection
  end

  def update(question_id, question_text, questionnaire_id, question_type_id)
    statement = @db.prepare("UPDATE questions SET question_text = ?, questionnaire_id = ?, question_type_id = ? WHERE question_id = ?")
    statement.execute(question_text, questionnaire_id, question_type_id, question_id)
  end

  def create(question_text, questionnaire_id, question_type_id)
    statement = @db.prepare("INSERT INTO questions (question_text, questionnaire_id, question_type_id) VALUES (?, ?, ?)")
    statement.execute(question_text, questionnaire_id, question_type_id)
  end

  def find_all_questions_by_questionnaire_id(questionnaire_id)
    statement = @db.prepare("SELECT * FROM questions WHERE questionnaire_id = ?")
    statement.execute(questionnaire_id).to_a
  end
end
