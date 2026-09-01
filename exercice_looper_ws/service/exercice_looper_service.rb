# frozen_string_literal: true

require 'mysql2'
require_relative '../db/database'
class ExerciceLooperService

  def initialize()
    @db = Database.connection
  end

  def create_questionnaire(title)
    puts "NOM DU QAuest #{title}"
    @db.prepare("INSERT INTO questionnaires (title) VALUES (?)").execute(title)
  end

  def fetch_all_questionnaires
    puts "Fetching all questionnaires"
    questionnaires = @db.query('SELECT * FROM questionnaires').to_a

    questionnaires.each do |questionnaire|
      puts questionnaire
    end

  end

  def create_question(question_text, questionnaire_id, question_type_id)

  end
end
