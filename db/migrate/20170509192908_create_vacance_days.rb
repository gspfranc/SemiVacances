class CreateVacanceDays < ActiveRecord::Migration[5.0]
  def change
    create_table :vacance_days do |t|
      t.integer :vacance_id
      t.date :date
      t.timestamps
    end


  end
end
