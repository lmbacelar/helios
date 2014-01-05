class FunctionPresenter < BasePresenter
  presents :function
  delegate :name, to: :function

  def show_link
    h.link_to 'Details', function
  end

  def destroy_link
    h.link_to 'Destroy', function, method: :delete, data: { confirm: 'Are you sure?' }
  end
end
