class PrtMeasurementsController < MeasurementsController
private
  def measurement_params
    params.require(:prt_measurement)
          .permit(:temperature, :resistance)
          .delete_if{ |k, v| v.blank? }
  end
end
