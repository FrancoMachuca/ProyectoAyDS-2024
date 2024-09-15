class CreateImagesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |u|
      u.string :image, null: false
      u.string :caption, null: false
      u.references :user, foreign_key: true
      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
