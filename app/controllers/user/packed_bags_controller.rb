class User::PackedBagsController < ApplicationController
  before_action :set_packed_bag, only: %i[show update destroy copy]
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
    @packed_bag = PackedBag.new(packed_bag_params)
    @journey = Journey.find(params[:packed_bag][:journey])
    @packed_bag.journey = @journey
    @packed_bag.bag = Bag.find(params[:packed_bag][:bag_id])
    if @packed_bag.save
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag), notice: 'Packed Bag created.' }
        format.js { render 'user/packed_bags/create' }
      end
    else
      @bag = Bag.new
      @templates = BagTemplate.all
      respond_to do |format|
        format.html { redirect_to user_journey_path(@journey), notice: 'Packed Bag not created.' }
        format.js { render 'user/packed_bags/create' }
      end
    end
  end

  def copy
    @copy = PackedBag.new
    @copy.name    = @packed_bag.name << ' - copy'
    @copy.bag     = @packed_bag.bag
    @copy.journey = Journey.find(params[:journey])
    if @copy.save
      @packed_bag.packed_items.each do |packed_item|
        @packed_item = PackedItem.new
        @packed_item.packed_bag = @copy
        @packed_item.item       = packed_item.item
        @packed_item.save
      end
      if @packed_bag.packed_items.count == @copy.packed_items.count
        respond_to do |format|
          format.html { redirect_to user_packed_bag_path(@copy), notice: 'Packed Bag copied' }
        end
      else
        @templates = BagTemplate.all
        @bag = Bag.new
        @packed_bag = PackedBag.new
        respond_to do |format|
          format.html { redirect_to user_journey_path(@journey), notice: 'Packed Bag not copied' }
        end
      end
    else
      @templates = BagTemplate.all
      @bag = Bag.new
      @packed_bag = PackedBag.new
      respond_to do |format|
        format.html { redirect_to user_journey_path(@journey), notice: 'Packed Bag not copied' }
      end
    end
  end

  def destroy
    @journey = @packed_bag.journey
    if @packed_bag.destroy
      respond_to do |format|
        format.html { redirect_to user_journey_path(@journey), notice: 'Packed Bag destroyed.' }
        format.js { render 'user/packed_bags/destroy' }
      end
    else
      @templates = BagTemplate.all
      @bag = Bag.new
      @packed_bag = PackedBag.new
      respond_to do |format|
        format.html { redirect_to user_journey_path(@journey), notice: 'Packed Bag not destroyed.' }
        format.js { render 'user/packed_bags/destroy' }
      end
    end
  end

  private

  def set_packed_bag
    @packed_bag = PackedBag.find(params[:id])
  end

  def packed_bag_params
    params.require(:packed_bag).permit(:name)
  end

  def set_filters
    @categories   = ItemCategory.all
    @references   = ItemReference.all
    @owned_items  = current_user.items
    @packed_items = @packed_bag.packed_items
    if params.key?("category")
      if params[:category].to_i > 0
        @references   = @references.where(category_id: params[:category])
        @owned_items  = Item.category(params[:category])
        @packed_items = PackedItem.packed(params[:category], @packed_bag)
      end
    end
  end
end
