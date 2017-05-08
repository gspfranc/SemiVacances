class VacancesController < ApplicationController
  before_action :set_vacance, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user
  before_action :vacances_view_authorisation
  before_action :approbation_authorisation, only: [:approuver, :refuser]

  # GET /vacances
  # GET /vacances.json
  def index
    #abort
    @vacances = Vacance.all.where("user" => params['user_id'].to_i)
  end

  # GET /vacances/1
  # GET /vacances/1.json
  def show
    redirect_to(root_path)
  end

  # GET /vacances/new
  def new
    #validate to see if user is autorised to create vacance
    @vacance = Vacance.new()
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
    approbation = Approbation.new()
    approbation.user = @current_user
    approbation.vacance = @current_vacances
    approbation.decision = 1
    approbation.save!
    redirect_to(root_path)
  end




  def refuser

    approbation = Approbation.new()
    approbation.user = @current_user
    approbation.vacance = @current_vacances
    approbation.decision = 2
    approbation.save!
    redirect_to(root_path)


  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_vacance
    @vacance = Vacance.find(params[:id])
  end


  def vacances_view_authorisation

    if action_name.in?(["edit","destroy","update"])
      #edit,destroy and update action is not permitted when approbation is present
      redirect_to(root_path, notice: "Ne peux editer ou supprimer une demande déja approuvé") if @vacance.approbation.present?
    end

    #user is not autorised to see page
    redirect_to(root_path) unless @current_user.is_admin || @current_user.is_gestionnaire ||
        @current_user.id == params['user_id'].to_i

  end


  def approbation_authorisation
    @current_vacances = Vacance.find(params['id'])
    #seul les admins et gestionnaires peuvent approuver
    unless @current_user.is_admin || @current_user.is_gestionnaire
      eturn redirect_to root_path, notice: "Utilisateur non autorisé à effectuer l'action"
    end

      #Gestionnaire ne peux autoriser ses propres vacances
    if @current_user.is_gestionnaire && @current_vacances.user == @current_user
      return redirect_to root_path, notice: "L'utilisateur ne peux effectuer cette action sur ses propres vacances"
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def vacance_params
    params.require(:vacance).permit(:date_start, :date_end, :commentaire)
  end
end
