class MeasurementPresenter < BasePresenter
  presents :measurement

  delegate :value, :unit, :quantity, to: :measurement

  def date
    measurement.created_at.to_date.iso8601
  end

  def time
    measurement.created_at.strftime "%H:%M:%S"
  end

  def destroy_link
    h.link_to 'Destroy',  [measurement.transfer_function, measurement], 
                          method: :delete,
                          data: { confirm: 'Are you sure?' }
  end
end
