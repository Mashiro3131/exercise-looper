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

  def find_by_id(questionnaire_id)
    statement = @db.prepare("SELECT * FROM questionnaires WHERE questionnaire_id = ?")
    statement.execute(questionnaire_id).first
  end

  def update(questionnaire_id, status)
    statement = @db.prepare("UPDATE questionnaires SET status = ? WHERE questionnaire_id = ?")
    statement.execute(status, questionnaire_id)
  end
end