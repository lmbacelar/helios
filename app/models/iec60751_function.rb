class Iec60751Function < ActiveRecord::Base
  include RetryMethods
  has_many  :measurements, as: :transfer_function, class_name: 'PrtMeasurement', dependent: :destroy
  validates :name, presence: true, uniqueness: true
 
  #
  # VALID TEMPERATURE RANGE
  #
  RANGE = -200.10..850.10

  def range
    RANGE
  end

  #
  # IEC 60751 R FUNCTION
  #
  def r t90
    t90 >= 0 ?
      r0*(1 + a*t90 + b*t90**2) :
      r0*(1 + a*t90 + b*t90**2 - 100*c*t90**3 + c*t90**4)
  end

  #
  # R INVERSE FUNCTION COMPUTATION
  #
  MAX_ITERATIONS = 10
  MAX_ERROR      = 1e-4

  def t90 r
    return 0 if r == r0
    t = t90_approximation r
    return Float::NAN if t.is_a? Complex
    MAX_ITERATIONS.times do
      slope = (r - r0) / t
      r_calc = r(t)
      break if (r_calc - r).abs < slope * MAX_ERROR
      t -= (r_calc - r) / slope
    end
    t
  end

  def t90_approximation r
    r >= r0 ?
      (-a + (a**2 - 4 * b * (1 - r / r0))**(0.5)) / (2 * b) :
      ((r / r0) - 1) / (a + 100 * b)
  end
end
