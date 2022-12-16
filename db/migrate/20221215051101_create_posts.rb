class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false, unique: true, limit: 255
      t.string :description, null: false
      t.integer :status, null: false, default: 1
      t.integer :create_user_id, null: false, foreign_key: true
      t.integer :updated_user_id, null: false, foreign_key: true
      t.integer :deleted_user_id

      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
