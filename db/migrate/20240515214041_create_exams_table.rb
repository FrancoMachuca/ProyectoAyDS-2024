class CreateExamsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :exams, primary_key: 'id_levels' do |u|
      u.integer :minScore
    end
  end
end
