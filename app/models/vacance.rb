class Vacance < ApplicationRecord
  validates_date :date_start
  validates_date :date_end, :on_or_after => :date_start

  has_many :vacance_days, :dependent => :destroy
  belongs_to :user

  scope :waiting_approbation, -> {Vacance.all.map {|x| x if x.status_open?}.compact}


  def status_open?
    return !self.closed.present?

  end

  def status_partial?
    #TODO  fix this
    max_approb = self.vacance_days.size
    return [1..(max_approb-1)].include?(self.vacance_days.map{|x| x if x.approbation.present?}.compact.size)

  end


  def status_close?
    return true if self.closed.present?

    open_vacance_day = self.vacance_days.map {|x| x if x.status_close?}.compact
    return open_vacance_day.size > 0
  end

  def status

    return "Demande partiel" if self.status_partial?
    self.status_open? ? "Demande ouverte" : "Demande fermé"
  end




end
