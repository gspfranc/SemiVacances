class VacanceDay < ApplicationRecord
  has_and_belongs_to_many :vacances

  validates :date, :presence => true, :uniqueness => true

  def self.date(date)
    VacanceDay.find_or_create_by(date:date)
  end
end
