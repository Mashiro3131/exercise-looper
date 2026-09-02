# frozen_string_literal: true

class QuestionnaireRepository
  def initialize(db_connection)
    @db = db_connection
  end

  def create(title)
    statement = @db.prepare("INSERT INTO questionnaires (title) VALUES (?)")
    statement.execute(title)
  end

  def find_all
    @db.query("SELECT * FROM questionnaires ").to_a
  end

  def update(questionnaire_id, status)
    statement = @db.prepare("UPDATE questionnaires SET status = ? WHERE questionnaire_id = ?")
    statement.execute(status, questionnaire_id)
  end
end