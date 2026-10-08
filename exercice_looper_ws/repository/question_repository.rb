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

  def find_question_type_id_by_description(description)
    statement = @db.prepare(
      "SELECT question_type_id 
      FROM question_types 
      WHERE description = ?"
      )

    row = statement.execute(description).first

    row && row["question_type_id"]
  end

  def find_all_questions_by_questionnaire_id(questionnaire_id)
    statement = @db.prepare(
      "SELECT questions.*, question_types.description AS question_type_description
      FROM questions
      INNER JOIN question_types ON question_types.question_type_id = questions.question_type_id
      WHERE questions.questionnaire_id = ?
      ORDER BY questions.question_id"
    )

    statement.execute(questionnaire_id).to_a
  end
end
