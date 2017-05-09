class UserMailer < ApplicationMailer
  default from: "francis@semiweb.ca"

  def new_user(user)
    @user = user
    @email = user.email

    mail to: @user.email, subject: 'You have been sign-up on SemiVacances'
  end
end
