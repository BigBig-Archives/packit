class User::PackedItemsController < ApplicationController
  before_action :set_packed_item, only: %i[destroy]
  before_action :set_item, only: %i[create]
  before_action :set_packed_bag, only: %i[create]

  def create
    @packed_item = PackedItem.new
    @packed_item.packed_bag = @packed_bag
    @packed_item.item = @item
    if @packed_item.save
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag, category: params[:category], display: params[:display]), notice: 'Packed item created.' }
        format.js { render '' }
      end
    else
      @categories = ItemCategory.all
      @references = ItemReference.all
      flash[:alert] = 'Error: ' << @journey.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { render '' }
      end
    end
  end

  def destroy
    @packed_bag = @packed_item.packed_bag
    if @packed_item.destroy
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag, category: params[:category], display: params[:display]), notice: 'Packed item destroyed.' }
        format.js { render '' }
      end
    else
      @categories = ItemCategory.all
      @references = ItemReference.all
      @packed_item = PackedItem.new
      flash[:alert] = 'Error: ' << @journey.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { render '' }
      end
    end
  end

  def set_packed_item
    @packed_item = PackedItem.find(params[:id])
  end

  def set_item
    @item = Item.find(params[:item])
  end

  def set_packed_bag
    @packed_bag = PackedBag.find(params[:packed_bag])
  end
end
