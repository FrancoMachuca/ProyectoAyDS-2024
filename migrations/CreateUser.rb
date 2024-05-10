require 'active_record'
class CreateUser < ActiveRecord::Migration[7.0]
    def change
        create_table :user do |u|
            u.int :id
            u.string :name
            u.string :mail
            u.string :password
            u.int :totalScore
        end
    end
end