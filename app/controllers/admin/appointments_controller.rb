class Admin::AppointmentsController < ApplicationController
  layout 'admin'
  before_action :set_appointment, only: %i[ show edit update destroy ]

  # GET /appointments or /appointments.json
  def index
    
  start_time = params.fetch(:start_time, Date.today).to_date
  @appointments = Appointment.where(start_time: start_time.beginning_of_month.beginning_of_week..start_time.end_of_month.end_of_week)

  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
   
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user_id = User.find(1).id
    respond_to do |format|
      if @appointment.save
        start_time = params.fetch(:start_time, Date.today).to_date
        @appointments = Appointment.where(start_time: start_time.beginning_of_month.beginning_of_week..start_time.end_of_month.end_of_week)
        format.turbo_stream
        format.html { redirect_to admin_appointments_url(@appointment), notice: "La cita se ha creado" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to appointment_url(@appointment), notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy!

    respond_to do |format|
      format.html { redirect_to appointments_url, notice: "Appointment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:start_time, :description, :pacient_id, :user_id)
    end
end
