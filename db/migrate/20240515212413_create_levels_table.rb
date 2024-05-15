class CreateLevelsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :levels, primary_key: 'id_levels' do |u|
      
      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
