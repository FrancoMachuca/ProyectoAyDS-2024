class CreateMultipleChoicesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :multiple_choices do |u|
      u.references :question, foreign_key: true

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end