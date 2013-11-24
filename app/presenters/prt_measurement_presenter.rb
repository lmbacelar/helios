class PrtMeasurementPresenter < MeasurementPresenter
  presents :measurement

  def temperature
    format "%.3f ºC", measurement.temperature
  end

  def resistance
    measurement.resistance ?
      format("%.4f Ohm", measurement.resistance) :
      '-----'
  end
end
