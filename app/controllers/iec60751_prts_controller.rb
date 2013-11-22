class Iec60751PrtsController < ApplicationController
  respond_to :html

  def index
    @prts = Iec60751Prt.all
    respond_with @prts
  end

  def new
    @prt ||= Iec60751Prt.new
  end

  def create
    @prt = Iec60751Prt.new prt_params
    flash[:notice] = 'PRT was successfully created' if @prt.save_and_retry_on_unique
    respond_with @prt
  end

  def show
    @prt = Iec60751Prt.find(params[:id])
    respond_with @prt
  end

  def destroy
    @prt = Iec60751Prt.find(params[:id])
    @prt.destroy
    flash[:notice] = 'PRT was successfully destroyed' 
    respond_with @prt
  end

protected
  def prt_params
    params.require(:iec60751_prt)
          .permit(:name, :r0, :a, :b, :c)
          .delete_if{ |k, v| v.blank? }
  end
end
