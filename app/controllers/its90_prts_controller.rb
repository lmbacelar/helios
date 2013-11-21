class Its90PrtsController < ApplicationController
  respond_to :html

  def index
    @prts = Its90Prt.all
    respond_with @prts
  end

  def new
    @prt ||= Its90Prt.new
  end

  def create
    @prt = Its90Prt.new prt_params
    flash[:notice] = 'PRT was successfully created' if @prt.save
    respond_with @prt
  end

  def show
    @prt = Its90Prt.find(params[:id])
    respond_with @prt
  end

  def destroy
    @prt = Its90Prt.find(params[:id])
    @prt.destroy
    flash[:notice] = 'PRT was successfully destroyed' 
    respond_with @prt
  end

protected
  def prt_params
    params.require(:its90_prt)
          .permit(:name, :sub_range,
                  :rtpw,
                  :a, :b, :c, :d, 
                  :w660, 
                  :c1, :c2, :c3, :c4, :c5)
          .delete_if{ |k, v| v.blank? }
  end
end
