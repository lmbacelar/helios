module Mti
  def belongs_to_mti parent
    # set belongs_to associations with children
    children = children_from parent
    children.each { |child| belongs_to child }

    # define parent association reader
    define_method(parent) do
      children.collect{ |child| self.send child }.compact.first
    end

    # define parent association writer
    define_method("#{parent}=") do |child|
      self.send self.class.child_assignment_method(child.class), child
    end
  end

  def child_assignment_method klass
    "#{symbolize_name(klass)}="
  end

  def children_from parent
    parent.to_s.classify.constantize.descendants.collect{ |child| symbolize_name child }.compact
  end

  private
  def symbolize_name klass
    klass.to_s.split('::').last.underscore.to_sym
  end
end

