class CreateAdminsTable < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |u|
      u.datetime :created_at
      u.datetime :updated_at
    end
  end
end
