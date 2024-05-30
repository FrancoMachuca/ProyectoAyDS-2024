class CreateMultipleChoiceAnswersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :multiple_choice_answers do |t|
      t.string :answer
      t.boolean :correct, default: false
      t.references :multiple_choice, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
