class VacanceDayController < ApplicationController
  before_filter :authenticate_user




  def approbation_select
    vacance_days_ids = params[:vacance_days_ids]
    decision = params[:approb_confirm].present? ? 'approved' : 'refused'
    vacance_days_ids.to_a.each do |vd_id|
      vd = VacanceDay.find(vd_id)
      approbation = vd.build_approbation(user: @current_user, decision: decision)
      approbation.save!
    end
    check_and_close_vacance(Vacance.find(params[:id]))
    redirect_to user_vacance_path
  end



  def check_and_close_vacance(vacance)
   need_approbation = vacance.vacance_days.map{|x| x unless x.approbation.present?}.compact
    if need_approbation.empty?
      vacance.update(closed: Time.now) #closing vacance request
    end
  end

end
