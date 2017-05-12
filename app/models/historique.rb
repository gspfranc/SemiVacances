class Historique < ApplicationRecord

  def to_s
    user = User.find(self.user_id) if self.user_id.present?

    vacance_id = User.find(self.user_id) if self.vacance_id.present?

    return "[#{user.username}] #{self.message} " if user

    else self.message

  end

end
