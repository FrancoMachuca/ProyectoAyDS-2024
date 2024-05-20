class CreateUserslevelsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users_levels do |u|
      u.references :user, foreign_key: true
      u.references :level, foreign_key: true

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
