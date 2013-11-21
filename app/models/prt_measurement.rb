class Iec60751Measurement < ActiveRecord::Base
  belongs_to :iec60751_prt

  validates :iec60751_prt, presence: true
  validate  :presence_of_temperature_or_resistance,
            :temperature_within_prt_range

  scope :latest, ->       { order created_at: :desc }
  scope :before, ->(time) { (Time.parse(time.to_s) rescue nil) ? where('created_at < ?', time) : all }
  scope :after,  ->(time) { (Time.parse(time.to_s) rescue nil) ? where('created_at > ?', time) : all }

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
    if temperature < iec60751_prt.class::RANGE.min || temperature > iec60751_prt.class::RANGE.max
      errors[:temperature] << 'not within range of PRT.'
    end
  end

  def presence_of_temperature_or_resistance
    if (self.temperature.to_s + self.resistance.to_s).empty?
      errors[:base] << 'Either temperature or resistance required.'
    end
  end
end
