# frozen_string_literal: true

# FallingObjects Table, a type of question
class CreateFallingObjectsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :falling_objects do |u|
      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
