class Iec60751FunctionsController < ApplicationController
  respond_to :html

  def index
    @functions = Iec60751Function.all
    respond_with @functions
  end

  def new
    @function ||= Iec60751Function.new
  end

  def create
    @function = Iec60751Function.new function_params
    flash[:notice] = 'Function was successfully created' if @function.save_and_retry_on_unique
    respond_with @function
  end

  def show
    @function = Iec60751Function.find(params[:id])
    respond_with @function
  end

  def destroy
    @function = Iec60751Function.find(params[:id])
    @function.destroy
    flash[:notice] = 'Function was successfully destroyed' 
    respond_with @function
  end

protected
  def function_params
    params.require(:iec60751_function)
          .permit(:name, :r0, :a, :b, :c)
          .delete_if{ |k, v| v.blank? }
  end
end
