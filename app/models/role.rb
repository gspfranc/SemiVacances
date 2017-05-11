class Role < ApplicationRecord
  has_and_belongs_to_many :users

  def self.get_role_by_s(role_s)
    return Role.where(role: role_s)
  end


end
