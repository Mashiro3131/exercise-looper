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
end
