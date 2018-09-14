class User::ItemsController < ApplicationController
  before_action :set_item, only: %i[update destroy]
  before_action :set_reference, only: %i[create]
  before_action :set_packed_bag, only: %i[create update destroy]
  before_action :set_filters

  def create
    @item = Item.new(item_params)
    @item.reference = @reference
    @item.user = current_user
    if params[:item][:quantity].to_i > 0 && params[:item][:quantity].to_i <= 9 && @item.save # max quantity: 9
      # if first item saved, so create the others without checking for errors
      # if params.key?(:create_and_pack) # if pack directly?
      #   @packed_item = PackedItem.new
      #   @packed_item.packed_bag = @packed_bag
      #   @packed_item.item = @item
      #   @packed_item.save
      # end
      params[:item][:quantity].to_i.-(1).times do
        @item = Item.new(item_params)
        @item.reference = @reference
        @item.user = current_user
        @item.save
        # if params.key?(:create_and_pack) # if pack directly?
        #   @packed_item = PackedItem.new
        #   @packed_item.packed_bag = @packed_bag
        #   @packed_item.item = @item
        #   @packed_item.save
        # end
      end
      filter
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
          notice: 'Item created.' }
        format.js { render 'user/items/create' }
        # if @filter_on_group == 'false'
        #   format.js { render 'user/items/create_ungroup' }
        # else
        #   format.js { render 'user/items/create_group' }
        # end
      end
    else
      @item.errors.add(:quantity, "should be between 1 and 9")
      @packed_item  = PackedItem.new
      filter
      flash[:alert] = 'Error: ' << @item.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { 'user/items/create' }
      end
    end
  end

  def update
    if @item.update(item_params)
      filter
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
          notice:   'Item updated.'}
        format.js { render 'user/items/update' }
      end
    else
      @packed_item  = PackedItem.new
      filter
      flash[:alert] = 'Error: ' << @item.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { render 'user/items/update' }
      end
    end
  end

  def destroy
    if params.key?(:destroy_all) && params[:destroy_all] == 'true'
      destroy_all
    else
      destroy_one
    end
  end

  def destroy_one
    item_name = @item.name
    if @item.destroy
      filter
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
          notice:   "1 #{item_name} destroyed." }
        format.js { render 'user/items/destroy' }
      end
    else
      filter
      flash[:alert] = 'Error: ' << @item.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/packed_bag/show' }
        format.js { render 'user/items/destroy' }
      end
    end
  end

  def destroy_all
    @reference = @item.reference
    @count     = @reference.items.select { |item| item.user == current_user }.count
    if Item.where(reference: @reference, user: current_user).destroy_all
      filter
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
          notice:   "#{@count} #{@count > 1 ? @reference.name.pluralize : @reference.name} have been destroyed." }
        format.js { render 'user/items/destroy' }
      end
    else
      flash[:alert] = 'Error: ' << 'Something went wrong'
      filter
      respond_to do |format|
        format.html { render 'user/packed_bag/show' }
        format.js { render 'user/items/destroy' }
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

  def set_filters
    if params.key?(:item)
      @filter_on_category  = params[:item][:category_filter]
      @filter_on_direction = params[:item][:direction_filter]
      @filter_on_group     = params[:item][:group_filter]
    else
      @filter_on_category  = params[:category]
      @filter_on_direction = params[:direction]
      @filter_on_group     = params[:group]
    end
  end

  def item_params
    params.require(:item).permit(:size, :weight)
  end
end
