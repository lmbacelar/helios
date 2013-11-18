class Iec60751MeasurementPresenter < BasePresenter
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

  def r0
    format "%.4f Ohm", measurement.r0
  end

  def a
    format "%+.5E", measurement.a
  end

  def b
    format "%+.5E", measurement.b
  end

  def c
    format "%+.5E", measurement.c
  end

  def destroy_link
    h.link_to 'Destroy', measurement, method: :delete, data: { confirm: 'Are you sure?' }
  end
end
