class PrtMeasurement < TemperatureMeasurement
  validate  :presence_of_temperature_or_resistance,
            :temperature_within_prt_range

  before_validation :update_temperature

  def resistance= r
    @resistance = r
  end

  def resistance
    temperature ? meter.r(temperature) : @resistance
  end

protected
  def update_temperature
    if temperature.blank? && resistance.present?
      self.temperature = meter.try(:t90, @resistance.to_f) 
    end
  end
  
  def temperature_within_prt_range
    return unless temperature && meter
    if temperature < meter.range.min || temperature > meter.range.max
      errors[:temperature] << 'not within range of PRT.'
    end
  end

  def presence_of_temperature_or_resistance
    if (self.temperature.to_s + self.resistance.to_s).empty?
      errors[:base] << 'Either temperature or resistance required.'
    end
  end
end
