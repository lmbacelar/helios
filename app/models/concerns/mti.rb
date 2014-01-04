module Mti
  def belongs_to_mti parent
    belongs_to_all children_from parent
    define_reader_for parent
    define_writer_for parent
  end

  def assignment_method klass
    "#{symbolize_name(klass)}="
  end

private
  def belongs_to_all models
    models.each { |model| belongs_to model }
  end

  def define_reader_for parent
    children = children_from parent
    define_method(parent) do
      children.collect{ |child| self.send child }.compact.first
    end
  end

  def define_writer_for parent
    define_method("#{parent}=") do |child|
      self.send self.class.assignment_method(child.class), child
    end
  end

  def children_from parent
    parent.to_s.classify.constantize.descendants.collect{ |child| symbolize_name child }.compact
  end

  def symbolize_name klass
    klass.to_s.split('::').last.underscore.to_sym
  end
end

