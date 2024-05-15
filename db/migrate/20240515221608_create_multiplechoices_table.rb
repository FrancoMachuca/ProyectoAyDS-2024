class CreateMultiplechoicesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :multiple_choices, primary_key: 'id_question' do |u|
      u.integer :number_answer

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
