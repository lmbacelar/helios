class Iec60751MeasurementsController < ApplicationController
  respond_to :html

  def index
    @from, @to = params[:from], params[:to]
    @measurements = Iec60751Measurement.latest.after(@from).before(@to)
    respond_with @measurements
  end

  def new
    @measurement ||= Iec60751Measurement.new 
    respond_with @recent_measurement
  end

  def create
    @measurement = Iec60751Measurement.new measurement_params
    flash[:notice] = "Measurement was successfully created" if @measurement.save
    respond_with @measurement
  end

  def show
    @measurement = Iec60751Measurement.find(params[:id])
    respond_with @recent_measurement
  end

  def destroy
    @measurement = Iec60751Measurement.find(params[:id])
    @measurement.destroy
    flash[:notice] = "Measurement was successfully destroyed" 
    respond_with @measurement
  end

  protected
  def measurement_params
    params.require(:iec60751_measurement)
          .permit(:resistance, :temperature, :r0, :a, :b, :c)
          .delete_if{ |k, v| v.blank? }
  end
end
