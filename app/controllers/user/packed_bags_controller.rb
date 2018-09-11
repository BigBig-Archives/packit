class User::PackedBagsController < ApplicationController
  before_action :set_packed_bag, only: %i[show update destroy]
  before_action :set_filters, only: %i[show]

  def show
    @packed_item  = PackedItem.new
    @item         = Item.new
    respond_to do |format|
      format.html { render 'user/packed_bags/show' }
      format.js { render 'user/packed_bags/sort' }
    end
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
      @templates = BagTemplate.all
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
      @templates = BagTemplate.all
      @bag = Bag.new
      respond_to do |format|
        format.html { redirect_to journeys_show_path(@journey), notice: 'Packed Bag not destroyed.' }
        format.js { render 'user/packed_bags/destroy' }
      end
    end
  end

  private

  def set_packed_bag
    @packed_bag = PackedBag.find(params[:id])
  end

  def packed_bag_params
    params.require(:packed_bag).permit.(:name)
  end

  def set_filters
    @categories   = ItemCategory.all
    @references   = ItemReference.all
    @owned_items  = current_user.items
    @packed_items = @packed_bag.packed_items
    if params.key?("category")
      if params[:category].to_i > 0
        @references   = @references.where(category_id: params[:category])
        @owned_items  = @owned_items.joins(:reference).where(item_references: { category_id: params[:category] })
        @packed_items = @packed_items.joins(item: [:reference]).where(item_references: { category_id: params[:category] })
      end
    end
  end
end
