class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username
      t.string :password_digest
      t.integer :role, default: 0, null: false   # можно добавить позже
      t.timestamps
    end
  end
end
