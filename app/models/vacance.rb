class Vacance < ApplicationRecord
  validates_date :date_start
  validates_date :date_end, :after => :date_start


  belongs_to :user


  has_one :approbation, :dependent => :delete
  has_one :user_approbation, through: :approbation, foreign_key: "vacance_id", class_name: "User"

  scope :waiting_approbation, -> { Vacance.all - Vacance.joins(:approbation) }

  attr :working_day

  def get_approbation_decision_s

    if self.approbation.present?
      return self.approbation.get_decision_s
    end
    return "En attente de decision"
  end


  def business_days_between

      working_day = 1
      working_date = self.date_end

      while working_date  > self.date_start
        working_day = working_day + 1 unless working_date.saturday? or working_date.sunday?
        working_date = working_date - 1.day
      end

    return working_day
  end








end
