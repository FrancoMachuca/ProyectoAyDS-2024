class CreateTocompleteTable < ActiveRecord::Migration[7.1]
  def change
    create_table :to_completes do |u|
      u.string :letters

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
