class ApplicationController < ActionController::Base
  protected
  def authenticate_user
    if session[:user_id]
      # set current user object to @current_user object variable
      @current_user = User.find session[:user_id]

      return true
    else
      redirect_to(:controller => 'sessions', :action => 'login')
      return false
    end
  end

  def admin_page_protect
    if session[:user_id]
      # set current user object to @current_user object variable
      @current_user = User.find session[:user_id]
      if !@current_user.is_admin
        redirect_to("/");
      end
    else
      redirect_to("/");
      return false
    end
  end


  def save_login_state
    if session[:user_id]
      redirect_to(:controller => 'sessions', :action => 'home')
      return false
    else
      return true
    end
  end
end
