class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :set_role, :user_view_authorisation]
  before_action :admin_page_protect, only: [:edit, :update, :destroy, :index]
  before_filter :authenticate_user, except:  [:new, :create]
  before_action :user_view_authorisation



  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end


  # PATCH/PUT /users/1
  def update

    #password is not changed
    unless params[:password].present?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
      format.js
      end
    end


  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Utilisateur créé avec succès"
      UserMailer.new_user(@user).deliver
      redirect_to users_url
    else
      flash[:notice] = "Form is invalid"
      render "new"
    end

  end

  def set_role

    unless @current_user.is_admin #only admin can set_role
      redirect_to root_path
      return false
    end

    if @user.update(role: params['role_id'].to_i)
      flash[:notice] = "Rôle modifié avec succès"
      redirect_to users_path
    else
      flash[:notice] = "Impossible de modifier le rôle de l'utilisateur"
      redirect_to users_path
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email, :password, :encrypted_password, :salt, :is_admin)
  end


  def user_view_authorisation
    if action_name.in?(["edit","destroy","index","show","update"]) #action that admin and gestionnaire can acces
      unless @current_user.is_admin || @current_user.is_gestionnaire || @current_user.id == params['id'].to_i
        redirect_to(root_path)
        return
      end
    end

    if action_name.in?(["destroy"])
      unless @current_user.is_admin || @current_user.is_gestionnaire #user cant destroy himself
        redirect_to(root_path)
        return
      end
    end
  end

end