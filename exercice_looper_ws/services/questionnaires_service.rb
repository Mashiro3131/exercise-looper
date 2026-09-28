# frozen_string_literal: true

class QuestionnairesService

  def initialize(questionnaire_repository)
    @questionnaire_repository = questionnaire_repository
  end

  def create_questionnaire(title)
    @questionnaire_repository.create(title)
  end

  def update_questionnaire(questionnaire_id, status)
    @questionnaire_repository.update(questionnaire_id,status)
  end

  def fetch_all_questionnaires
    @questionnaire_repository.find_all
  end

  def fetch_questionnaire_by_questionnaire_id(questionnaire_id)
    @questionnaire_repository.find_by_id(questionnaire_id)
  end

end
