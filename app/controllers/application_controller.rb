class ApplicationController < ActionController::Base
  helper_method :user_in_role?

  protected
  def authenticate_user
    if session[:user_id]
      # set current user object to @current_user object variable
      @current_user = User.find session[:user_id]
      return true
    else
      redirect_to(login_path)
      return false
    end
  end

  def admin_page_protect
    if session[:user_id]
      # set current user object to @current_user object variable
      @current_user = User.find session[:user_id]
      if !@current_user.user_in_role?("admin")
        redirect_to(root_path);
      end
    else
      redirect_to(root_path);
      return false
    end
  end


  def save_login_state
    if session[:user_id]
      redirect_to(home_path)
      return false
    else
      return true
    end
  end



end
