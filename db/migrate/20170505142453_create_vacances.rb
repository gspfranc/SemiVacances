class CreateVacances < ActiveRecord::Migration[5.0]
  def change
    create_table :vacances do |t|
      t.date :date_start
      t.date :date_end
      t.text :commentaire
      t.integer :user_id
      t.timestamps
    end
  end
end