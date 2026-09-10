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

  def render_exercises_page
    file_path = File.expand_path("../../exercises.html", __dir__)
    
    return "Fichier introuvable" unless File.exist?(file_path)

    html = File.read(file_path, encoding: "UTF-8")
    parts = html.split(/(?=<h1>\s*(?:Building|Answering|Closed)\s*<\/h1>)/i)

    parts.map! do |part|
      if part.match?(/<h1>\s*Building\s*<\/h1>/i)
        part.sub(/(<tbody[^>]*>).*?(<\/tbody>)/m, "\\1\n#{generate_rows('editing')}\n\\2")
      elsif part.match?(/<h1>\s*Answering\s*<\/h1>/i)
        part.sub(/(<tbody[^>]*>).*?(<\/tbody>)/m, "\\1\n#{generate_rows('answering')}\n\\2")
      elsif part.match?(/<h1>\s*Closed\s*<\/h1>/i)
        part.sub(/(<tbody[^>]*>).*?(<\/tbody>)/m, "\\1\n#{generate_rows('closed')}\n\\2")
      else
        part
      end
    end

    parts.join
  end

  private

  def generate_rows(status)
    records = @questionnaire_repository.find_all_questionnaires_by_status(status)
    return "" if records.nil? || records.empty?

    records.map do |q|
      case status
      when "editing"
        <<~HTML
          <tr>
            <td>#{q['title']}</td>
            <td>
              <a title="Be ready for answers" rel="nofollow" data-method="put" href="exercises/#{q['id']}.html?exercise%5Bstatus%5D=answering"><i class="fa fa-comment"></i></a>
              <a title="Manage fields" href="exercises/#{q['questionnaire_id']}/fields.html"><i class="fa fa-edit"></i></a>
              <a data-confirm="Are you sure?" title="Destroy" rel="nofollow" data-method="delete" href="exercises/#{q['id']}.html"><i class="fa fa-trash"></i></a>
            </td>
          </tr>
        HTML
      when "answering"
        <<~HTML
          <tr>
            <td>#{q['title']}</td>
            <td>
              <a title="Show results" href="exercises/#{q['id']}/results.html"><i class="fa fa-chart-bar"></i></a>
              <a title="Close" rel="nofollow" data-method="put" href="exercises/#{q['id']}.html?exercise%5Bstatus%5D=closed"><i class="fa fa-minus-circle"></i></a>
            </td>
          </tr>
        HTML
      when "closed"
        <<~HTML
          <tr>
            <td>#{q['title']}</td>
            <td>
              <a title="Show results" href="exercises/#{q['id']}/results.html"><i class="fa fa-chart-bar"></i></a>
              <a data-confirm="Are you sure?" title="Destroy" rel="nofollow" data-method="delete" href="exercises/#{q['id']}.html"><i class="fa fa-trash"></i></a>
            </td>
          </tr>
        HTML
      end
    end.join
  end
end