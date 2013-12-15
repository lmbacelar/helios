class Its90FunctionsController < ApplicationController
  respond_to :html

  def index
    @functions = Its90Function.all
    respond_with @functions
  end

  def new
    @function ||= Its90Function.new
  end

  def create
    @function = Its90Function.new function_params
    flash[:notice] = 'Function was successfully created' if @function.save_and_retry_on_unique
    respond_with @function
  end

  def show
    @function = Its90Function.find(params[:id])
    respond_with @function
  end

  def destroy
    @function = Its90Function.find(params[:id])
    @function.destroy
    flash[:notice] = 'Function was successfully destroyed' 
    respond_with @function
  end

protected
  def function_params
    params.require(:its90_function)
          .permit(:name, :sub_range,
                  :rtpw,
                  :a, :b, :c, :d, 
                  :w660, 
                  :c1, :c2, :c3, :c4, :c5)
          .delete_if{ |k, v| v.blank? }
  end
end
