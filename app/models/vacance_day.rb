class VacanceDay < ApplicationRecord
  belongs_to :vacance

  has_one :approbation, :dependent => :destroy
  has_one :user_approbation, through: :approbation, foreign_key: "vacance_day_id", class_name: "User"


  validates :date, :presence => true

  def get_decision_s
    return "waiting" if self.status_open?
    self.approbation.decision
  end

  def get_decision_user_s
    return "none" unless self.approbation.present?
    self.approbation.user.username
  end

  def status_close?
    return self.approbation.present?
  end

  def status_open?
    return !self.status_close?
  end


  def self.to_csv
    attributes = %w{user date decision approbator}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.order(:date).each do |vacance_day|
        approbation_user = vacance_day.approbation.present? ? vacance_day.approbation.user.username : ""
        csv << [vacance_day.vacance.user.username, vacance_day.date ,vacance_day.get_decision_s, approbation_user]
      end
    end
  end

end
