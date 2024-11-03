# frozen_string_literal: true

# Images Table for the profile
class CreateImagesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |u|
      u.string :image, null: false
      u.string :caption, null: false

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
