class Vacance < ApplicationRecord
belongs_to :user

  def business_days_between
    working_day = 1
    working_date = self.date_end
    #abord
    while working_date  > self.date_start
      working_day = working_day+ 1 unless working_date.saturday? or working_date.sunday?
      working_date = working_date - 1.day
    end
    working_day
  end

end
