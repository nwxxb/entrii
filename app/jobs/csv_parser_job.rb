class CsvParserJob < ApplicationJob
  queue_as :default

  def perform(questionnaire_id, file_content)
    if file_content.blank?
      raise CSV::MalformedCSVError.new("empty", 0)
    end

    questionnaire = Questionnaire.find(questionnaire_id)

    Questionnaire.transaction do
      questions = {}
      counter = 0
      CSV.parse(file_content.split("\n", 2).first) do |head|
        head.each_with_index do |h, i|
          questions[h] = Question.create!(name: h, position: i, questionnaire: questionnaire, is_emptyable: true)
        end
      end

      CSV.parse(file_content, headers: true, skip_blanks: true, skip_lines: /#/) do |row|
        if row.fields.compact.present?
          submission = Submission.create!(questionnaire: questionnaire)

          questions.each do |h, question|
            if counter == 0
              if /\A[\d\.]+\z/.match?(row[h])
                question.number!
              end
            end

            if row[h].present?
              submission.submission_values.create!(value: row[h], question: question, questionnaire: questionnaire)
            end
          end

          counter += 1
        end
      end
    end
  end
end
