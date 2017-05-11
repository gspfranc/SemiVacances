class ReportController < ApplicationController

  before_action :authenticate_user
  before_action :check_report_permission



  def user_report
    require 'csv'
    @users = User.all

    if params[:user_id].present?
      @user = User.find(params['user_id'])

      if request.post?
        @start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i,params[:start_date][:day].to_i)
        @end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i,params[:end_date][:day].to_i)
      else
        @start_date = params[:start_date].to_date
        @end_date = params[:end_date].to_date
      end
      vacance_user_id = @user.vacances.map{|x| x.id if x.user_id == @user.id}
      @all_vacance_day = VacanceDay.where(:vacance_id => vacance_user_id, :date => @start_date..@end_date)


      #defining column and column name to display
      @all_vacance_day = @all_vacance_day.map {|x| {
          'vacance_id' => x.vacance.id, 'created'=> x.vacance.updated_at,
          'date'=> x.date.to_s, 'decision' => x.get_decision_s, 'User approbation' => x.get_decision_user_s
      }}

    end

    respond_to do |format|
      format.html { render template: "reports/user_report" }
      format.csv { send_data @all_vacance_day.first.keys.to_csv << @all_vacance_day.map{|x| x.values.to_csv}.join(), filename: "User_report_#{@user.username}_.csv" }
    end

  end

  def check_report_permission
    redirect_to root_path unless @current_user.user_in_role?("report_maker")
  end




end
