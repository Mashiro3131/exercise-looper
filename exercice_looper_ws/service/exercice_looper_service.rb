# frozen_string_literal: true

class ExerciceLooperService
  def initialize(questionnaire_repository, questions_repository)
    @questionnaire_repository = questionnaire_repository
    @questions_repository = questions_repository
  end

  def create_questionnaire(title)
    questionnaire_id = @questionnaire_repository.create(title)

    template_path = File.expand_path("../../exercises/templates/created", __dir__)
    new_questionnaire_path = File.expand_path("../../exercises/#{questionnaire_id}", __dir__)

    if Dir.exist?(template_path)
      Dir.mkdir(new_questionnaire_path) unless Dir.exist?(new_questionnaire_path)

      Dir.glob("#{template_path}/*").each do |file_path|
        file_name = File.basename(file_path)
        destination_path = File.join(new_questionnaire_path, file_name)

        if File.file?(file_path)
          content = File.read(file_path)
          content  = content.gsub("N/A", title)
          File.write(destination_path, content)
        end
      end
    end

    questionnaire_id
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

  # ================== QUESTIONS =====================

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