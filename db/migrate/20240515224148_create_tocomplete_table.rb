class CreateTocompleteTable < ActiveRecord::Migration[7.1]
  def change
    create_table :to_completes, primary_key: 'id_question' do |u|
      u.string :letters

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
