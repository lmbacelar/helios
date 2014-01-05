class Its90FunctionPresenter < FunctionPresenter
  delegate :sub_range, to: :function

  def rtpw
    format "%.6f Ohm", function.rtpw
  end

  def a
    format "%+.6E", function.a
  end

  def b
    format "%+.6E", function.b
  end

  def c
    format "%+.6E", function.c
  end

  def d
    format "%+.6E", function.d
  end

  def w660
    format "%+.6E", function.w660
  end

  def c1
    format "%+.6E", function.c1
  end

  def c2
    format "%+.6E", function.c2
  end

  def c3
    format "%+.6E", function.c3
  end

  def c4
    format "%+.6E", function.c4
  end

  def c5
    format "%+.6E", function.c5
  end
end
