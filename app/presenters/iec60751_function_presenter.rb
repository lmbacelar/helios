class Iec60751FunctionPresenter < FunctionPresenter
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
end
