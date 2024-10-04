class CreateTranslationsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :translations do |u|
      

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
