# frozen_string_literal: true

class CreateAnswersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.string :answer
      t.boolean :correct
      t.references :question, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
