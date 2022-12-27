class ChangeProfileDefaultValueToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :profile, 'default.png'
  end
end
