class EnsureSubmissionValueSubmissionAndQuestionHaveSameQuestionnaire < ActiveRecord::Migration[6.1]
  def up
    add_reference :submission_values, :questionnaire, null: false
    add_index :questions, [:questionnaire_id, :id], unique: true
    add_index :submissions, [:questionnaire_id, :id], unique: true

    execute <<-SQL
      ALTER TABLE submission_values
      ADD CONSTRAINT fk_submission_values_submissions
      FOREIGN KEY (questionnaire_id, submission_id)
      REFERENCES submissions(questionnaire_id, id)
    SQL

    execute <<-SQL
      ALTER TABLE submission_values
      ADD CONSTRAINT fk_submission_values_questions
      FOREIGN KEY (questionnaire_id, question_id)
      REFERENCES questions(questionnaire_id, id)
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE submission_values
      DROP CONSTRAINT fk_submission_values_submissions
    SQL

    execute <<-SQL
      ALTER TABLE submission_values
      DROP CONSTRAINT fk_submission_values_questions
    SQL

    remove_index :questions, [:questionnaire_id, :id], unique: true
    remove_index :submissions, [:questionnaire_id, :id], unique: true

    remove_reference :submission_values, :questionnaire
  end
end
