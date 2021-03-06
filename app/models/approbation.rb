class Approbation < ApplicationRecord
  belongs_to :user
  belongs_to :vacance_day

  DECISION_CHOICE = %w(approved refused)


  validates :user_id, :presence => true
  validates :vacance_day_id, :presence => true
  validates :decision, :presence => true, :inclusion=> { :in => DECISION_CHOICE }

  def get_decision_s
    return self.decision
  end

end

