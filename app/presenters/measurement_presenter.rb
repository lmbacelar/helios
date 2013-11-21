class MeasurementPresenter < BasePresenter
  presents :measurement

  delegate :value, :unit, :quantity, to: :measurement

  def date
    measurement.created_at.to_date.iso8601
  end

  def time
    measurement.created_at.strftime "%H:%M:%S"
  end
end
