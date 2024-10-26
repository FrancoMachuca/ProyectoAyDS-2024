class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |u|
      u.string :name
      u.string :mail
      u.string :password
      u.integer :userable_id
      u.string :userable_type
      u.references :image, foreign_key: true

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
