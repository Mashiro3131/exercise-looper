class AnswerRepository
  def initialize(db_connection)
    @db = db_connection
  end

  def create_submission(questions, answers)
    @db.query("START TRANSACTION")

    begin
      insert = @db.prepare(
        "INSERT INTO answers (submission_id, question_id, answer_text) VALUES (?, ?, ?)"
      )

      submission_id = nil

      questions.each do |question|
        question_id = question["question_id"]
        insert.execute(submission_id, question_id, answers[question_id.to_s].to_s)

        if submission_id.nil?
          submission_id = @db.last_id
          update = @db.prepare("UPDATE answers SET submission_id = ? WHERE answer_id = ?")
          update.execute(submission_id, submission_id)
        end
      end

      @db.query("COMMIT")
      submission_id
    rescue StandardError
      @db.query("ROLLBACK")
      raise
    end
  end

  def find_answers(questionnaire_id, submission_id)
    statement = @db.prepare(
      "SELECT answers.question_id, answers.answer_text
       FROM answers
       INNER JOIN questions ON questions.question_id = answers.question_id
       WHERE answers.submission_id = ? AND questions.questionnaire_id = ?
       ORDER BY answers.question_id"
    )

    statement.execute(submission_id, questionnaire_id).to_a
  end

  def update_submission(submission_id, questions, answers)
    @db.query("START TRANSACTION")

    begin
      statement = @db.prepare(
        "UPDATE answers SET answer_text = ? WHERE submission_id = ? AND question_id = ?"
      )

      questions.each do |question|
        question_id = question["question_id"]
        statement.execute(answers[question_id.to_s].to_s, submission_id, question_id)
      end

      @db.query("COMMIT")
    rescue StandardError
      @db.query("ROLLBACK")
      raise
    end
  end
end
