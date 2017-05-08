class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.integer :role, :default => "P" # 0 = user, 1= gestionnaire, 2 = admin
      t.timestamps
    end
  end
end