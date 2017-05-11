class User < ActiveRecord::Base
  has_many :vacances, :dependent => :delete_all


  has_many :approbation, :dependent => :nullify
  has_many :vacances_approb, through: :approbation, :foreign_key => :user_approb_id, class_name: "Vacances"
  has_and_belongs_to_many :roles

  attr_accessor :password
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }, :on => [:save,:update]
  validates :email, :presence => true, :uniqueness => true, :on => [:save,:update]
  validates_length_of :password, :in => 6..20, :on => [:save]
  validates :password, :confirmation => true #password_confirmation attr
  #todo regex of email

  before_save :encrypt_password
  after_save :clear_password

  def get_all_role_s


    return self.roles.map {|x| x.role}.join", "

  end


  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end

  def self.authenticate(user_to_check, login_password)

    user_list = User.where(username: user_to_check.to_s)

    if user_list.count > 0  && user_list.take.match_password(login_password.to_s)
      return user_list.take
    else
      return false
    end
  end


  def match_password(login_password)
    self.encrypted_password == BCrypt::Engine.hash_secret(login_password.to_s, salt)
  end


  def self.user_in_role?(user,role ="", bypass = false) #if bypass = true, admin user will not return true
    user_roles = user.roles.map{|x| x.role}
    return user_roles.include?(role) if bypass
    return user_roles.include?(role) || user_roles.include?("admin") #admin bypass all
  end


  def user_in_role?(role ="", bypass = false) #if bypass = true, admin user will not return true
    user_roles = self.roles.map{|x| x.role}
    return user_roles.include?(role) if bypass
    return user_roles.include?(role) || user_roles.include?("admin") #admin bypass all
  end


end