class Vacance < ApplicationRecord
  validates_date :date_start
  validates_date :date_end, :after => :date_start

  belongs_to :user
  has_and_belongs_to_many :vacance_days

  has_one :approbation, :dependent => :delete
  has_one :user_approbation, through: :approbation, foreign_key: "vacance_id", class_name: "User"

  scope :waiting_approbation, -> { Vacance.all - Vacance.joins(:approbation) }


  before_save :generate_vacances_day


  def get_approbation_decision_s

    if self.approbation.present?
      return self.approbation.get_decision_s
    end
    return "En attente de decision"
  end


  def business_days_between
    return self.vacance_days.size
    #TODO returning all day....to be fix

  end



  def generate_vacances_day
    self.vacance_days.delete_all
    working_date = self.date_end
    while working_date  > self.date_start
      current_vacance_day = VacanceDay.date(working_date)
      self.vacance_days.push(current_vacance_day)
      working_date = working_date - 1.day
    end

  end








end
