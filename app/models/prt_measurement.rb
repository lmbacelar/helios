class PrtMeasurement < TemperatureMeasurement
  validate  :presence_of_temperature_or_resistance,
            :temperature_within_prt_range

  before_validation :update_temperature

  def resistance= r
    @resistance = r
  end

  def resistance
    temperature ? transfer_function.r(temperature) : @resistance
  end

protected
  def update_temperature
    if temperature.blank? && resistance.present?
      self.temperature = transfer_function.try(:t90, @resistance.to_f) 
    end
  end
  
  def temperature_within_prt_range
    return unless temperature && transfer_function
    if temperature < transfer_function.range.min || temperature > transfer_function.range.max
      errors[:temperature] << 'not within range of PRT.'
    end
  end

  def presence_of_temperature_or_resistance
    if (self.temperature.to_s + self.resistance.to_s).empty?
      errors[:base] << 'Either temperature or resistance required.'
    end
  end
end
