# frozen_string_literal: true

class CreateTutorialsTable < ActiveRecord::Migration[7.2]
  def change
    create_table :tutorials do |u|
      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
