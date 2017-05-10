class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :role, index: true
      t.timestamps
    end

    create_table :roles_users do |t|
      t.integer :user_id
      t.integer :role_id
      t.timestamps
    end


  end
end
