class Approbation < ApplicationRecord
  belongs_to :user
  belongs_to :vacance

  def get_decision_s
    return case self.decision
             when 1
               "Approuvé"
             when 2
               "Refusé"
             else
               "En attente"
           end
  end

  def is_approved
    return self.decision == 1
  end



end

