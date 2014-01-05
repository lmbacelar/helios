class Iec60584FunctionPresenter < FunctionPresenter
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

  def show_link
    h.link_to 'Details', function
  end

  def destroy_link
    h.link_to 'Destroy', function, method: :delete, data: { confirm: 'Are you sure?' }
  end
end
