# frozen_string_literal: true

class ExerciceLooperService
  def initialize(questionnaire_repository, questions_repository)
    @questionnaire_repository = questionnaire_repository
    @questions_repository = questions_repository
  end

  def create_questionnaire(title)
    puts "Nom du questionnaire : #{title}"
    @questionnaire_repository.create(title)
  end

  def update_questionnaire(questionnaire_id, status)
    @questionnaire_repository.update(questionnaire_id,status)
  end

  def fetch_all_questionnaires
    puts "Fetching all questionnaires"
    @questionnaire_repository.find_all
  end

  def create_question(question_text, questionnaire_id, question_type_id)
    puts "Nom du question crée: #{question_text}"
    @questions_repository.create(question_text, questionnaire_id, question_type_id)
  end

  def update_question(question_id,question_text, questionnaire_id, question_type_id)
    puts "Nom et ID du question MAJ: #{question_text}, #{question_id}"
    @questions_repository.update(question_id,question_text, questionnaire_id, question_type_id)
  end

  def find_all_questions_by_questionnaire_id(questionnaire_id)
    @questions_repository.find_all_questions_by_questionnaire_id(questionnaire_id)
  end

end