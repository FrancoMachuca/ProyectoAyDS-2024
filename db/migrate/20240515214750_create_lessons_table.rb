class CreateLessonsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :lesson, primary_key: 'id_level' do |u|
      u.string :help

      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
