class User::PackedBagsController < ApplicationController
  before_action :set_packed_bag, only: %i[show update destroy]

  def show
    @items = ItemRef.all
    @packed_item = PackedItem.new

    # Filters
    params.key?("category")
  end

  def create
    @packed_bag = PackedBag.new
    @packed_bag.bag = Bag.find(params[:bag])
    @packed_bag.journey = Journey.find(params[:journey])
    if @packed_bag.save
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag), notice: 'Packed Bag created.' }
        format.js { render 'user/packed_bags/create' }
      end
    else
      @references = BagRef.all
      respond_to do |format|
        format.html { redirect_to journeys_show_path(@journey), notice: 'Packed Bag not created.' }
        format.js { render 'user/packed_bags/create' }
      end
    end
  end

  def destroy
    if @packed_bag.destroy
      respond_to do |format|
        format.html { redirect_to journeys_show_path(@journey), notice: 'Packed Bag destroyed.' }
        format.js { render 'user/packed_bags/destroy' }
      end
    else
      @references = BagRef.all
      @bag = Bag.new
      respond_to do |format|
        format.html { redirect_to journeys_show_path(@journey), notice: 'Packed Bag not destroyed.' }
        format.js { render 'user/packed_bags/destroy' }
      end
    end
  end

  def set_packed_bag
    @packed_bag = PackedBag.find(params[:id])
  end

  def packed_bag_params
    params.require(:packed_bag).permit.(:name)
  end
end
