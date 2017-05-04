class UsersController < ApplicationController
  #before_filter :authenticate_user, :only => [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :admin_page_protect, only: [:edit, :update, :create, :destroy, :index]

    # GET /users
    # GET /users.json
    def index
      @users = User.all
    end

    # GET /users/1
    # GET /users/1.json
    def show
    end

    # GET /users/new
    def new
      @user = User.new
    end

    # GET /users/1/edit
    def edit
      @user = User.find(params['id'])
    end

    # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to users_url, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
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
      end
    end


  def create
    @user = User.new(user_params)
    if @user.save
      p "GOOD"
      flash[:notice] = "Utilisateur créé avec succès"
      redirect_to users_url
    else
      p "BAD"
      flash[:notice] = "Form is invalid"
      redirect_to "new"
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


end
