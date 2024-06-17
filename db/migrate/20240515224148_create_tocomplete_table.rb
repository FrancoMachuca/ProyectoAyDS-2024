class CreateTocompleteTable < ActiveRecord::Migration[7.1]
  def change
    create_table :to_completes do |u|
      u.string :keyword
      u.string :toCompleteMorse

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
