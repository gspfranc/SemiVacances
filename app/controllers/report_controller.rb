class ReportController < ApplicationController

  before_action :authenticate_user
  before_action :check_report_permission



  def user_report
    require 'csv'
    @users = User.all

    if request.post?
      @user = User.find(params['user_id'])
      @start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i,params[:start_date][:day].to_i)
      @end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i,params[:end_date][:day].to_i)
      vacance_user_id = @user.vacances.map{|x| x.id if x.user_id == @user.id}
      @all_vacance_day = VacanceDay.where(:vacance_id => vacance_user_id, :date => @start_date..@end_date)

    end

    respond_to do |format|
      format.html { render template: "reports/user_report" }
      format.csv {
        @user = User.find(params['user_id'])
        vacance_user_id = @user.vacances.map{|x| x.id if x.user_id == @user.id}
        vacance_user = VacanceDay.where(:vacance_id => vacance_user_id)
        send_data vacance_user.to_csv, filename: "User_report_#{@user.username}_.csv" }
    end

  end


  def check_report_permission
    redirect_to root_path unless @current_user.user_in_role?("report_maker")
  end




end
