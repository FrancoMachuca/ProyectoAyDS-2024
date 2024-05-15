class CreateExamsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :exams, primary_key: 'id_levels' do |u|
      u.integer :minScore

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
