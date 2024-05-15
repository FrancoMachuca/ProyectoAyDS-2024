class CreateLevelsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :levels, primary_key: 'id_levels' do |u| 
    end
  end
end
