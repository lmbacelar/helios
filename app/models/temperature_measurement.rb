class TemperatureMeasurement < Measurement
  alias_attribute   :temperature,  :value

  before_validation :set_quantity

protected
  def set_quantity
    self.quantity = :temperature
  end
end
