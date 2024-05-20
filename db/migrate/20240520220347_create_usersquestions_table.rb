class CreateUsersquestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users_questions do |u|
      u.references :user, foreign_key: true
      u.references :question, foreign_key: true

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
