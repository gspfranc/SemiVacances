class RolesController < ApplicationController


  def edit
    @user = User.find(params[:id])
    @roles = Role.all

    if request.post?
      @user.roles.delete_all
      if params[:role_ids].present?
        params[:role_ids].each do |role_id|
          @user.roles.push(Role.find(role_id))
        end
      end
      return redirect_to users_path
    end


  end
end