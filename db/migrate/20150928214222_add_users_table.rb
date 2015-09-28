class AddUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :role, default: 'admin', null: false
      t.string :name, null: false
      t.string :password_digest, null: false
    end
  end
end
