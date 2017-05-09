class Approbation < ApplicationRecord
  belongs_to :user
  belongs_to :vacance

  DECISION_CHOICE = %w(approved refused)


  validates :user_id, :presence => true
  validates :vacance_id, :presence => true
  validates :decision, :presence => true, :inclusion=> { :in => DECISION_CHOICE }




  def get_decision_s
    return self.decision
  end

  def is_approved
    return self.decision == 'approved'
  end



end

