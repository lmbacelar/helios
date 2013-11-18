class Iec60751Measurement < ActiveRecord::Base

  TEMPERATURE_RANGE = -200.10..850.10
  MAX_ITERATIONS    = 10
  MAX_ERROR         = 1e-4

  validate  :presence_of_temperature_or_resistance
  validates :temperature, numericality: { greater_than_or_equal_to: TEMPERATURE_RANGE.min, 
                                          less_than_or_equal_to:    TEMPERATURE_RANGE.max }

  scope :recent, -> { order created_at: :desc }

  def resistance= r
    return unless r
    return if temperature
    self.temperature = get_t90 r.to_f
  end

  def resistance
    return unless temperature
    get_r temperature
  end

protected
  def get_r t90
    t90 >= 0 ?
      r0*(1 + a*t90 + b*t90**2) :
      r0*(1 + a*t90 + b*t90**2 - 100*c*t90**3 + c*t90**4)
  end

  def get_t90_approximation r
    r >= r0 ?
      (-a + (a**2 - 4 * b * (1 - r / r0))**(0.5)) / (2 * b) :
      ((r / r0) - 1) / (a + 100 * b)
  end

  def get_t90 r
    return 0 if r == r0
    t90 = get_t90_approximation r
    return Float::NAN if t90.is_a? Complex
    MAX_ITERATIONS.times do
      slope = (r - r0) / t90
      r_calc = get_r t90
      break if (r_calc - r).abs < slope * MAX_ERROR
      t90 -= (r_calc - r) / slope
    end
    t90
  end

  def presence_of_temperature_or_resistance
    if (self.temperature.to_s + self.resistance.to_s).empty?
      msg = 'Either temperature or resistance required.'
      errors[:temperature] << msg
      errors[:resistance]  << msg
    end
  end
end
