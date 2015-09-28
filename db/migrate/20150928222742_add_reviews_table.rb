class AddReviewsTable < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title, null: false
      t.string :text, null: false, length: 2048
      t.integer :user_id, null: false
    end
  end
end
