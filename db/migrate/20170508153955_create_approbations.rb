class CreateApprobations < ActiveRecord::Migration[5.0]
  def change
    create_table :approbations do |t|
      t.integer :vacance_day_id
      t.integer :user_id
      t.string :decision
      t.text :commentaire
      t.timestamps
    end
  end
end
