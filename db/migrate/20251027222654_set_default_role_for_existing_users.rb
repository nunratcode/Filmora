class SetDefaultRoleForExistingUsers < ActiveRecord::Migration[8.0]
  def up
    # выставляем дефолтную роль для всех пользователей
    execute "UPDATE users SET role = 0 WHERE role IS NULL"
  end

  def down
    # откат: сбрасываем роли до NULL
    execute "UPDATE users SET role = NULL"
  end
end