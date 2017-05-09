class CreateVacanceDays < ActiveRecord::Migration[5.0]
  def change
    create_table :vacance_days do |t|
      t.date :date
      t.timestamps
    end

    create_table :vacance_days_vacances do |t|
      t.integer :vacance_id
      t.integer :vacance_day_id
      t.timestamps
    end

  end
end
