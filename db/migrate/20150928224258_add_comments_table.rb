class AddCommentsTable < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :text, null: false, lenght: 1024
      t.integer :review_id, null: false
      t.integer :user_id, null: false
    end
  end
end
