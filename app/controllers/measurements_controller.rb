class MeasurementsController < ApplicationController
  respond_to :html

  before_action :load_transfer_function

  def index
    @from, @to = params[:from], params[:to]
    @measurements = @transfer_function.measurements.latest.after(@from).before(@to)
    @measurement_type = @measurements.new.type.underscore.to_sym
    respond_with @measurements
  end

  def new
    @measurement ||= @transfer_function.measurements.new 
  end

  def create
    @measurement = @transfer_function.measurements.new measurement_params
    flash[:notice] = 'Measurement was successfully created' if @measurement.save
    respond_with @transfer_function, @measurement
  end

  def show
    @measurement = @transfer_function.measurements.find(params[:id])
    respond_with @transfer_function, @measurement
  end

  def destroy
    @transfer_function.measurements.find(params[:id]).destroy
    flash[:notice] = 'Measurement was successfully destroyed' 
    respond_with @transfer_function, :measurements
  end

private
  def load_transfer_function
    resource, id = request.path.split('/')[1, 2]
    @transfer_function = resource.singularize.classify.constantize.find(id)
  end

  def measurement_params
    params.require(:measurement).permit(:value, :unit)
  end
end
