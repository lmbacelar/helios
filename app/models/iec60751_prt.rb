class Iec60751Prt < ActiveRecord::Base

  MAX_ITERATIONS = 10
  MAX_ERROR      = 1e-4
  RANGE          = -200.10..850.10

  has_many  :iec60751_measurements, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def r t90
    t90 >= 0 ?
      r0*(1 + a*t90 + b*t90**2) :
      r0*(1 + a*t90 + b*t90**2 - 100*c*t90**3 + c*t90**4)
  end

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
