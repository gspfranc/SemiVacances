class CreateHistoriques < ActiveRecord::Migration[5.0]
  def change
    create_table :historiques do |t|
      t.string :message
      t.integer :user_id
      t.integer :vacance_id
      t.timestamps
    end
  end
end
