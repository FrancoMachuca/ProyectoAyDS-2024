# frozen_string_literal: true

# multiple_choice Table, a type of question
class CreateMultipleChoicesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :multiple_choices do |u|
      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
