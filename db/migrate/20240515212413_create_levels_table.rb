class CreateLevelsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :levels do |u|

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
