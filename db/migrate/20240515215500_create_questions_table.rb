class CreateQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |u|
      u.string :description
      u.references :level, foreign_key: true
      u.integer :questionable_id
      u.string :questionable_type

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
