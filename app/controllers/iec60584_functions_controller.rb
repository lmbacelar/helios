class Iec60584FunctionsController < ApplicationController
  respond_to :html

  def index
    @functions = Iec60584Function.all
    respond_with @functions
  end

  def new
    @function ||= Iec60584Function.new
  end

  def create
    @function = Iec60584Function.new function_params
    flash[:notice] = 'Function was successfully created' if @function.save_and_retry_on_unique
    respond_with @function
  end

  def show
    @function = Iec60584Function.find(params[:id])
    respond_with @function
  end

  def destroy
    @function = Iec60584Function.find(params[:id])
    @function.destroy
    flash[:notice] = 'Function was successfully destroyed' 
    respond_with @function
  end

protected
  def function_params
    params.require(:iec60584_function)
          .permit(:name, :type, :a3, :a2, :a1, :a0)
          .delete_if{ |k, v| v.blank? }
  end
end
