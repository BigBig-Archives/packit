class User::PackedItemsController < ApplicationController
  before_action :set_reference, only: %i[create destroy]
  before_action :set_packed_bag, only: %i[create destroy]

  def create
    @packed_item = PackedItem.new
    @packed_item.packed_bag = @packed_bag
    @packed_item.item_ref = @reference
    if @packed_item.save
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag, category: params[:category], owned: params[:owned]), notice: 'packed item created.' }
        format.js { render '' }
      end
    else
      @categories = ItemCategory.all
      @items = ItemRef.all
      respond_to do |format|
        format.html { render 'user/packed_bags/show', notice: 'packed item not created.' }
        format.js { render '' }
      end
    end
  end

  def destroy
    if @packed_item.destroy
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag), notice: 'packed item destroyed.' }
        format.js { render '' }
      end
    else
      @categories = ItemCategory.all
      @items = ItemRef.all
      @packed_item = PackedItem.new
      respond_to do |format|
        format.html { render 'user/packed_bags/show', notice: 'packed item not destroyed.' }
        format.js { render '' }
      end
    end
  end

  def set_reference
    @reference = ItemRef.find(params[:reference])
  end

  def set_packed_bag
    @packed_bag = PackedBag.find(params[:packed_bag])
  end
end
