class User < ActiveRecord::Base
  attr_accessor :password
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true
  # validates_length_of :password, :in => 6..20, :on => :create
  validates :password, :confirmation => true #password_confirmation attr

  before_save :encrypt_password
  after_save :clear_password

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
    end
  end


  def clear_password
    self.password = nil
  end

  def self.authenticate(user_to_check="", login_password="")

      user_list = User.where(username: user_to_check)

    if user_list.count > 0  && user_list.take.match_password(login_password)
      return user_list.take
    else
      return false
    end
  end


  def match_password(login_password="")
    self.encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end


end