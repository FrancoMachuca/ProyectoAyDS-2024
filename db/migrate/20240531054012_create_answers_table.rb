class CreateAnswersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.belongs_to :question, foreign_key: true
      t.string :answer
      t.boolean :correct

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
