class User::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_reference, only: %i[create]
  before_action :set_packed_bag, only: %i[create update destroy]

  def create
    @item = Item.new(item_params)
    @item.reference = @reference
    @item.user = current_user
    if @item.save
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag, category: params[:item][:category_filter], display: params[:item][:display_filter]), notice: 'Item created.' }
        format.js { }
      end
    else
      @packed_item  = PackedItem.new
      set_filters
      respond_to do |format|
        format.html { render 'user/packed_bags/show', notice: 'Item not created.' }
        format.js { }
      end
    end
  end

  def update
    if @item.update(item_params)
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag, category: params[:item][:category_filter], display: params[:item][:display_filter]), notice: 'Item updated.' }
        format.js { }
      end
    else
      @packed_item  = PackedItem.new
      set_filters
      respond_to do |format|
        format.html { render 'user/packed_bags/show', notice: 'Item not updated.' }
        format.js { }
      end
    end
  end

  def destroy
    if @item.destroy
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag, category: params[:category], display: params[:display]), notice: 'Item destroyed.' }
        format.js { }
      end
    else
      respond_to do |format|
        format.html { render 'user/packed_bag/show', notice: 'Item not destroyed.' }
        format.js { }
      end
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_reference
    @reference = ItemReference.find(params[:item][:reference])
  end

  def set_packed_bag
    if params.key?(:item)
      @packed_bag = PackedBag.find(params[:item][:packed_bag])
    else
      @packed_bag = PackedBag.find(params[:packed_bag])
    end
  end

  def item_params
    params.require(:item).permit(:size, :weight)
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
