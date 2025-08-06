class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :name, null: false, default: ""
      t.text :description, null: false, default: ""
      t.string :value_type, null: false
      t.boolean :is_emptyable, null: false, default: false
      t.integer :position, null: false
      t.references :questionnaire, null: false, foreign_key: true

      t.timestamps
    end
  end
end
