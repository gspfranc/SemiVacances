class VacancesController < ApplicationController
  before_action :set_vacance, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user

  # GET /vacances
  # GET /vacances.json
  def index
    @vacances = Vacance.all
  end

  # GET /vacances/1
  # GET /vacances/1.json
  def show

  end

  # GET /vacances/new
  def new
    @vacance = Vacance.new()

  end

  # GET /vacances/1/edit
  def edit
  end

  # POST /vacances
  # POST /vacances.json
  def create
    @vacance = Vacance.new(vacance_params)
    @vacance.user_id = params[:user_id]
    respond_to do |format|
      if @vacance.save
        format.html { redirect_to user_vacances_path, notice: 'Vacance was successfully created.' }
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
        format.html { redirect_to user_vacances_path, notice: 'Vacance was successfully updated.' }
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
      format.html { redirect_to user_vacances_path, notice: 'Vacance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

   private
    # Use callbacks to share common setup or constraints between actions.
    def set_vacance
      @vacance = Vacance.find(params[:id])
    end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def vacance_params
      params.require(:vacance).permit(:date_start, :date_end, :commentaire)
    end
end
