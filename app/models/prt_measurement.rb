class PrtMeasurement < TemperatureMeasurement
  belongs_to :iec60751_prt, class_name: 'Iec60751Prt', 
                            foreign_key: :instrument_id

  validate  :presence_of_temperature_or_resistance,
            :temperature_within_prt_range

  before_validation :update_temperature

  def resistance= r
    @resistance = r
  end

  def resistance
    temperature ? iec60751_prt.r(temperature) : @resistance
  end

protected
  def update_temperature
    if temperature.blank? && resistance.present?
      self.temperature = iec60751_prt.try(:t90, @resistance.to_f) 
    end
  end
  
  def temperature_within_prt_range
    return unless temperature && iec60751_prt
    if temperature < iec60751_prt.class.range.min || temperature > iec60751_prt.class.range.max
      errors[:temperature] << 'not within range of PRT.'
    end
  end

  def presence_of_temperature_or_resistance
    if (self.temperature.to_s + self.resistance.to_s).empty?
      errors[:base] << 'Either temperature or resistance required.'
    end
  end
end
