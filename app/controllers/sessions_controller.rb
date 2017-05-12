class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting]
  before_filter :save_login_state, :only => [:login, :login_attempt]


  def login
    #Login Form
  end

  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "Vous êtes connecté en tant que #{authorized_user.username}"
      redirect_to(:action => 'home')
    else
      flash[:notice] = "Invalid Username or Password"
      flash[:color]= "invalid"
      render "login"
    end
  end


  def logout
    session[:user_id] = nil
    redirect_to :action => 'login'
  end

  def home
    @my_vacances = @current_user.vacances
    @vacances_wainting_approb = Vacance.waiting_approbation
    @historique = Historique.order(id: :desc).take(15)

  end

  def profile
  end

  def setting
  end
end
