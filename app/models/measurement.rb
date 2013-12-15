class Measurement < ActiveRecord::Base
  validates :value, presence: true, numericality: true

  scope :latest, ->       { order created_at: :desc }
  scope :before, ->(time) { (Time.parse(time.to_s) rescue nil) ? where('created_at < ?', time) : all }
  scope :after,  ->(time) { (Time.parse(time.to_s) rescue nil) ? where('created_at > ?', time) : all }


  #
  # TODO: Extract this to a concern
  #       build method programmatically
  #       Something like 
  #       include Mti
  #       belongs_to_mti :transfer_function, 
  #                      [:iec60751_function, :its90_function] (optional. default to all descendants)
  #
  belongs_to :iec60751_function
  belongs_to :its90_function

  def transfer_function
    association_methods(TransferFunction).collect{ |f| self.send f }.compact.first
  end

  def transfer_function= f
    self.send reflection_assignment_method(f.class), f
  end

private
  def reflection_symbol klass
    klass.to_s.split('::').last.underscore.to_sym
  end

  def association_methods base_class
    base_class.descendants.collect{ |klass|
      self.class.reflect_on_association(reflection_symbol(klass)).try(:name)
    }.compact
  end

  def reflection_assignment_method klass
    self.class.reflect_on_association(reflection_symbol(klass)).name.to_s + '='
  end
end
