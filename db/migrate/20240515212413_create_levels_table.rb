# frozen_string_literal: true

class CreateLevelsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :levels do |u|
      u.string :name
      u.integer :playable_id
      u.string :playable_type

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
