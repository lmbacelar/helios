class Iec60751FunctionPresenter < BasePresenter
  presents :function

  delegate :name, to: :function

  def r0
    format "%.4f Ohm", function.r0
  end

  def a
    format "%+.5E", function.a
  end

  def b
    format "%+.5E", function.b
  end

  def c
    format "%+.5E", function.c
  end

  def show_link
    h.link_to 'Details', function
  end

  def destroy_link
    h.link_to 'Destroy', function, method: :delete, data: { confirm: 'Are you sure?' }
  end
end
