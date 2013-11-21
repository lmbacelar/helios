class Its90PrtPresenter < BasePresenter
  presents :prt

  delegate :name, :sub_range, to: :prt

  def rtpw
    format "%.6f Ohm", prt.rtpw
  end

  def a
    format "%+.6E", prt.a
  end

  def b
    format "%+.6E", prt.b
  end

  def c
    format "%+.6E", prt.c
  end

  def d
    format "%+.6E", prt.d
  end

  def w660
    format "%+.6E", prt.w660
  end

  def c1
    format "%+.6E", prt.c1
  end

  def c2
    format "%+.6E", prt.c2
  end

  def c3
    format "%+.6E", prt.c3
  end

  def c4
    format "%+.6E", prt.c4
  end

  def c5
    format "%+.6E", prt.c5
  end

  def show_link
    h.link_to 'Details', prt
  end

  def destroy_link
    h.link_to 'Destroy', prt, method: :delete, data: { confirm: 'Are you sure?' }
  end
end
