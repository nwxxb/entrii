class CreateSubmissionValues < ActiveRecord::Migration[6.1]
  def change
    create_table :submission_values do |t|
      t.references :submission, null: false, foreign_key: true
      t.json :value
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
