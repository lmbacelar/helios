class MeasurementsController < ApplicationController
  respond_to :html

  before_action :load_meter

  def index
    @from, @to = params[:from], params[:to]
    @measurements = @meter.measurements.latest.after(@from).before(@to)
    @measurement_type = @measurements.new.type.underscore.to_sym
    respond_with @measurements
  end

  def new
    @measurement ||= @meter.measurements.new 
  end

  def create
    @measurement = @meter.measurements.new measurement_params
    flash[:notice] = 'Measurement was successfully created' if @measurement.save
    respond_with @meter, @measurement
  end

  def show
    @measurement = @meter.measurements.find(params[:id])
    respond_with @meter, @measurement
  end

  def destroy
    @meter.measurements.find(params[:id]).destroy
    flash[:notice] = 'Measurement was successfully destroyed' 
    respond_with @meter, :measurements
  end

private
  def load_meter
    resource, id = request.path.split('/')[1, 2]
    @meter = resource.singularize.classify.constantize.find(id)
  end

  def measurement_params
    params.require(:measurement).permit(:value, :unit)
  end
end
