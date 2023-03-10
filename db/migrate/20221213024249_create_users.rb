class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, unique: true
      t.string :email, null:  false, unique: true
      t.string "password_digest", null: false
      # t.text :password, null:  false
      t.index ["email"], name: "index_users_on_email", unique: true
      t.string :profile, null: false, limit: 255, default: "default.png"
      t.string :role, default: 1, limit: 1
      t.string :phone, limit: 20
      t.string :address, limit: 255
      t.datetime :dob
      t.integer :create_user_id, null: false, foreign_key: true
      t.integer :updated_user_id, null: false, foreign_key:true
      t.integer :deleted_user_id

      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
