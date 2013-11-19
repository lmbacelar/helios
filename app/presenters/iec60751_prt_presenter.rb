class Iec60751PrtPresenter < BasePresenter
  presents :prt

  delegate :name, :description, to: :prt

  def r0
    format "%.4f Ohm", prt.r0
  end

  def a
    format "%+.5E", prt.a
  end

  def b
    format "%+.5E", prt.b
  end

  def c
    format "%+.5E", prt.c
  end

  def show_link
    h.link_to 'Details', prt
  end

  def destroy_link
    h.link_to 'Destroy', prt, method: :delete, data: { confirm: 'Are you sure?' }
  end
end
