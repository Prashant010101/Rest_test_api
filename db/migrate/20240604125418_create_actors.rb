class CreateActors < ActiveRecord::Migration[7.1]
  def change
    create_table :actors do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
