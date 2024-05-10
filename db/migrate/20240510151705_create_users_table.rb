class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :user do |u|
        u.string :name
        u.string :mail
        u.string :password
        u.integer :totalScore

        u.datetime :created_at
        u.datetime :updated_at
    end
  end
end

