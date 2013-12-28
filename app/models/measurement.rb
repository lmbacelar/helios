class Measurement < ActiveRecord::Base
  extend Mti
  belongs_to_mti :transfer_function

  validates :value, presence: true, numericality: true

  scope :latest, ->       { order created_at: :desc }
  scope :before, ->(time) { (Time.parse(time.to_s) rescue nil) ? where('created_at < ?', time) : all }
  scope :after,  ->(time) { (Time.parse(time.to_s) rescue nil) ? where('created_at > ?', time) : all }
end
