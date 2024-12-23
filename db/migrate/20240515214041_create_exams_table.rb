# frozen_string_literal: true

# Exams Table, a type of level
class CreateExamsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :exams do |u|
      u.integer :minScore

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
