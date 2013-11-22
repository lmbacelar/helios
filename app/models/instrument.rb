class Instrument < ActiveRecord::Base
  has_many :measurements
end
