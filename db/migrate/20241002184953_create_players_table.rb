# frozen_string_literal: true

# Players Table, a type of User
class CreatePlayersTable < ActiveRecord::Migration[7.2]
  def change
    create_table :players do |u|
      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
