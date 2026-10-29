
class AnswersService
  def initialize(answer_repository)
    @answer_repository = answer_repository
  end

  def create_submission(questions, answers)
    raise ArgumentError, "Questionnaire has no questions" if questions.empty?
    raise ArgumentError, "Invalid answers" unless answers.is_a?(Hash)

    @answer_repository.create_submission(questions, answers)
  end

  def find_answers(questionnaire_id, submission_id)
    @answer_repository.find_answers(questionnaire_id, submission_id)
  end

  def update_submission(submission_id, questions, answers)
    raise ArgumentError, "Invalid answers" unless answers.is_a?(Hash)

    @answer_repository.update_submission(submission_id, questions, answers)
  end
end
