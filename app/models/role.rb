class Role < ApplicationRecord
  has_and_belongs_to_many :users

  ROLE_LIST = %w(admin gestionnaire report_maker)
  validates :role, :uniqueness => true, :presence => true, :inclusion=> { :in => ROLE_LIST }

  def self.get_role_by_s(role_s)
    return Role.where(role: role_s)
  end


end
