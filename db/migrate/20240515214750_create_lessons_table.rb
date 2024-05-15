class CreateLessonsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :lesson, primary_key: 'id_level' do |u|
      u.string :help
    end
  end
end
