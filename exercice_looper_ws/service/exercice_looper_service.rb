# frozen_string_literal: true

class ExerciceLooperService
  def initialize(questionnaire_repository)
    @questionnaire_repository = questionnaire_repository
  end

  def create_questionnaire(title)
    puts "Nom du questionnaire : #{title}"
    @questionnaire_repository.create(title)
  end

  def fetch_all_questionnaires
    puts "Fetching all questionnaires"

    @questionnaire_repository.find_all
  end
end