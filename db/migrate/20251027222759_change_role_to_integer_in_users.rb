class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[8.0]
  def up
    # создаём временный столбец
    add_column :users, :role_tmp, :integer, default: 0, null: false

    # конвертируем старые значения в числа
    execute <<-SQL
      UPDATE users
      SET role_tmp = CASE role
        WHEN 'user' THEN 0
        WHEN 'creator' THEN 1
        WHEN 'admin' THEN 2
        ELSE 0
      END
    SQL

    # удаляем старый столбец и переименовываем новый
    remove_column :users, :role
    rename_column :users, :role_tmp, :role
  end

  def down
    add_column :users, :role_tmp, :string
    execute <<-SQL
      UPDATE users
      SET role_tmp = CASE role
        WHEN 0 THEN 'user'
        WHEN 1 THEN 'creator'
        WHEN 2 THEN 'admin'
        ELSE 'user'
      END
    SQL
    remove_column :users, :role
    rename_column :users, :role_tmp, :role
  end
end