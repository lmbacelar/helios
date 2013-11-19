class Iec60751Prt < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
end
