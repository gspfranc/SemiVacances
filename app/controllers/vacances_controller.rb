class VacancesController < ApplicationController
  before_action :set_vacance, only: [:show, :edit, :update, :destroy,:approuver,:refuser]
  before_filter :authenticate_user
  before_action :vacances_view_authorisation
  before_action :vacances_check_approbation_present, only: [:edit, :destroy,:update]
  before_action :approbation_authorisation, only: [:approuver, :refuser]
  after_action :generate_vacances_day, only: [:update,:create]

  # GET /vacances
  # GET /vacances.json
  def index
    #abort
    @vacances = Vacance.all.where("user" => params['user_id'].to_i)
  end

  # GET /vacances/new
  def new
    #validate to see if user is autorised to create vacance
    @vacance = Vacance.new
  end

  def show
    @vacance = Vacance.find(params['id'])

    if request.post?
      #TODO
      #VacanceDays_ids are in params['vacances_days_ids']
      #test params['approb_confirm'] to know what submit has been clicked
    end

  end


  # GET /vacances/1/edit
  def edit
    redirect_to(root_path) unless @current_user.id == params[:user_id].to_i
  end

  # POST /vacances
  # POST /vacances.json
  def create
    @vacance = Vacance.new(vacance_params)
    @vacance.user_id = params[:user_id]
    respond_to do |format|
      if @vacance.save
        format.html { redirect_to root_path, notice: 'Vacance was successfully created.' }
        format.json { render :show, status: :created, location: @vacance }
      else
        format.html { render :new }
        format.json { render json: @vacance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vacances/1
  # PATCH/PUT /vacances/1.json
  def update
    respond_to do |format|
      if @vacance.update(vacance_params)
        format.html { redirect_to root_path, notice: 'Vacance was successfully updated.' }
        format.json { render :show, status: :ok, location: @vacance }
      else
        format.html { render :edit }
        format.json { render json: @vacance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vacances/1
  # DELETE /vacances/1.json
  def destroy
    @vacance.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Vacance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def approuver

    Approbation.transaction do
      @vacance.vacance_days.each do |vd|
        approbation = vd.build_approbation(user: @current_user, decision: 'approved')
        approbation.save
      end
    end
    @vacance.update_attribute('closed',Time.now)
    redirect_to(root_path)
  end

  def refuser

    Approbation.transaction do
      @vacance.vacance_days.each do |vd|
        approbation = vd.build_approbation(user: @current_user, decision: 'refused')
        approbation.save
      end
    end
    @vacance.update_attribute('closed',Time.now)
    redirect_to(root_path)
  end





  private
  # Use callbacks to share common setup or constraints between actions.
  def set_vacance
    @vacance = Vacance.find(params[:id])
  end

  def vacances_check_approbation_present

    redirect_to(root_path, notice: "Ne peux editer ou supprimer une demande déja approuvé") unless @vacance.status_open?

  end



  def vacances_view_authorisation

    #user is not autorised to see page
    redirect_to(root_path) unless  @current_user.user_in_role?("gestionnaire") || @current_user.id == params['user_id'].to_i

  end


  def approbation_authorisation
    @current_vacances = Vacance.find(params['id'])
    #seul les admins et gestionnaires peuvent approuver
    unless @current_user.user_in_role?("gestionnaire")
      return redirect_to root_path, notice: "Utilisateur non autorisé à effectuer l'action"
    end

    #Admin sont les seuls a pouvoir s'auto approuver
    if !@current_user.user_in_role?("admin") && @current_vacances.user == @current_user
      return redirect_to root_path, notice: "L'utilisateur ne peux effectuer cette action sur ses propres vacances"
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def vacance_params
    params.require(:vacance).permit(:date_start, :date_end, :commentaire)
  end
end


def generate_vacances_day
  @vacance.vacance_days.destroy_all
  working_date = @vacance.date_end
  VacanceDay.transaction do
    while working_date  > @vacance.date_start-1
      @vacance.vacance_days.create(date: working_date) unless working_date.saturday? || working_date.sunday?
      working_date = working_date - 1.day
    end
  end

end
