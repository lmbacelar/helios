class Iec60584FunctionPresenter < FunctionPresenter
  delegate :type, to: :function

  def a3
    format "%+.5E", function.a3
  end

  def a2
    format "%+.5E", function.a2
  end

  def a1
    format "%+.5E", function.a1
  end

  def a0
    format "%+.5E", function.a0
  end
end
