class User < ActiveRecord::Base
  has_many :vacances
  attr_accessor :password
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }, :on => [:save,:update]
  validates :email, :presence => true, :uniqueness => true, :on => [:save,:update]
  validates_length_of :password, :in => 6..20, :on => [:save]
  validates :password, :confirmation => true #password_confirmation attr

  before_save :encrypt_password
  after_save :clear_password

  def is_admin
    self.role == 2
  end

  def is_gestionnaire
    self.role == 1
  end

  def is_user
    !is_admin && !is_gestionnaire
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


end