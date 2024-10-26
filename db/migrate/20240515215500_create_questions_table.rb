# frozen_string_literal: true

class CreateQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |u|
      u.string :description
      u.references :level, foreign_key: true
      u.integer :questionable_id
      u.string :questionable_type
      u.integer :times_answered_correctly, default: 0
      u.integer :times_answered_incorrectly, default: 0

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
