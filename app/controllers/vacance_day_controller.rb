class VacanceDayController < ApplicationController
  before_filter :authenticate_user
  before_action :check_role_for_approb, on: [:approbation_vacancedays]
  before_action :check_admin_for_cancel_approbation, on: [:cancel_all_approbation]

  def approbation_vacancedays
    if params[:approb_one].present?
      set_approbation([params[:approb_one].flatten.first],'approved')
    elsif params[:refuse_one].present?
      set_approbation([params[:refuse_one].flatten.first],'refused')
    elsif params[:approb_checkbox].present?
      set_approbation(params[:vacance_days_ids],'approved')
    elsif params[:refuse_checkbox].present?
      set_approbation(params[:vacance_days_ids],'refused')
    elsif params[:cancel_approbation].present?
      cancel_all_approbation()
    end
    check_and_close_vacance(Vacance.find(params[:id]))
    redirect_to user_vacance_path
  end


  def set_approbation(vacance_days_ids, decision)
    vacance_days_ids.to_a.each do |vd_id|
      vd = VacanceDay.find(vd_id)
      approbation = vd.build_approbation(user: @current_user, decision: decision)
      approbation.save!
    end
  end


  def cancel_all_approbation

    current_vacance = Vacance.find(params['id'])
    current_vacance.vacance_days.each do |vd|
      vd.approbation.destroy if vd.approbation.present?
    end
    current_vacance.update_attribute('closed', nil)
  end



  def check_and_close_vacance(vacance)
    need_approbation = vacance.vacance_days.map{|x| x unless x.approbation.present?}.compact
    if need_approbation.empty?
      vacance.update(closed: Time.now) #closing vacance request
    end
  end


  def check_role_for_approb
    return redirect_to root_path unless @current_user.user_in_role?('gestionnaire')

    current_vacance = Vacance.find(params['id'])

    #Admin sont les seuls a pouvoir s'auto approuver
    if !@current_user.user_in_role?('admin') && current_vacance.user == @current_user
      return redirect_to user_vacance_path, notice: "L'utilisateur ne peux effectuer cette action sur ses propres vacances"
    end
  end


  def check_admin_for_cancel_approbation
    return redirect_to user_vacance_path unless @current_user.user_in_role?('admin')
  end


end
