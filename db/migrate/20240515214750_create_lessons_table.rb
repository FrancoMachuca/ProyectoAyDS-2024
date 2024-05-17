class CreateLessonsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons, primary_key: 'id_lesson' do |u|
      u.string :help

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
