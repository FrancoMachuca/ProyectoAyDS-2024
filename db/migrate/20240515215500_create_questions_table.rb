class CreateQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions, primary_key: 'id_question' do |u|
      u.string :description
      u.references :level, foreign_key: {to_table: :levels, primary_key: :id_level}

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
