# frozen_string_literal: true

# Lessons Table, a type of level
class CreateLessonsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |u|
      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
