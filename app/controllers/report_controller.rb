class ReportController < ApplicationController

  def user_report
    @users = User.all

    if request.post?
      @user = User.find(params['user_id'])
      @start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i,params[:start_date][:day].to_i)
      @end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i,params[:end_date][:day].to_i)

    end

    render template: "reports/user_report"
  end


end
