class CreateRankingsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :rankings do |t|
      t.references :user, foreign_key: true
      t.references :level, foreign_key: true
      t.integer :userLevelScore

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
