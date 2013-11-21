class PrtMeasurementsController < ApplicationController
  respond_to :html

  before_action :set_prt

  def index
    @from, @to = params[:from], params[:to]
    @measurements = @prt.prt_measurements.latest.after(@from).before(@to)
    respond_with @measurements
  end

  def new
    @measurement ||= @prt.prt_measurements.new 
  end

  def create
    @measurement = @prt.prt_measurements.new measurement_params
    flash[:notice] = 'Measurement was successfully created' if @measurement.save
    respond_with @prt, @measurement
  end

  def show
    @measurement = @prt.prt_measurements.find(params[:id])
    respond_with @prt, @measurement
  end

  def destroy
    @measurement = @prt.prt_measurements.find(params[:id])
    @measurement.destroy
    flash[:notice] = 'Measurement was successfully destroyed' 
    respond_with @prt, @measurement
  end

private
  def set_prt
    @prt = Iec60751Prt.find params[:iec60751_prt_id]
  end

  def measurement_params
    params.require(:prt_measurement)
          .permit(:temperature, :resistance)
          .delete_if{ |k, v| v.blank? }
  end
end
