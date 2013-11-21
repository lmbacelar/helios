class PrtMeasurementPresenter < BasePresenter
  presents :measurement

  def temperature
    format "%.3f ºC", measurement.temperature
  end

  def resistance
    format "%.4f Ohm", measurement.resistance
  end

  def date
    measurement.created_at.to_date.iso8601
  end

  def time
    measurement.created_at.strftime "%H:%M:%S"
  end

  def destroy_link
    h.link_to 'Destroy',  h.iec60751_prt_prt_measurement_path(measurement.iec60751_prt, measurement), 
                          method: :delete,
                          data: { confirm: 'Are you sure?' }
  end
end