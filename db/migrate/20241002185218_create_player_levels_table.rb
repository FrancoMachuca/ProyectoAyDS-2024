# frozen_string_literal: true

# PlayerLevels Table, a relationship between players and the levels they play
class CreatePlayerLevelsTable < ActiveRecord::Migration[7.2]
  def change
    create_table :player_levels do |t|
      t.references :player, foreign_key: true
      t.references :level, foreign_key: true
      t.integer :playerLevelScore

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
