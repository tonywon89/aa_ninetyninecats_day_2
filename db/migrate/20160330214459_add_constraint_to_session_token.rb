class AddConstraintToSessionToken < ActiveRecord::Migration
  def change
    change_column_null :users, :session_token, false
  end
end
