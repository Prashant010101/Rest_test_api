class AddColoumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_activated, :boolean, default: false
  end
end
