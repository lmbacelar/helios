class Measurement < ActiveRecord::Base
  belongs_to :meter, polymorphic: true

  validates :value, presence: true, numericality: true

  scope :latest, ->       { order created_at: :desc }
  scope :before, ->(time) { (Time.parse(time.to_s) rescue nil) ? where('created_at < ?', time) : all }
  scope :after,  ->(time) { (Time.parse(time.to_s) rescue nil) ? where('created_at > ?', time) : all }
end
