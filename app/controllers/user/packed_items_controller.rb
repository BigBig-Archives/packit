class User::PackedItemsController < ApplicationController
  before_action :set_filters

  def create
    if params.key?(:pack_all) && params[:pack_all] == 'true'
      pack_all
    elsif params.key?(:packed_item) && params[:packed_item][:pack_many] == 'true'
      pack_many
    else
      pack_one
    end
  end

  def update
    params.key?(:packed_item) && params[:packed_item][:unpack_many] == 'true' ? unpack_many : unpack_one
  end

  def destroy
    set_packed_bag # @packed_bag
    count = @packed_bag.packed_items.count
    if @packed_bag.packed_items.destroy_all
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
          notice: "All the #{count} items have been unpacked from the bag" }
        format.js {  }
      end
    else
      flash[:alert] = 'Error: ' << 'Something went wrong'
      @packed_item  = PackedItem.new
      @item         = Item.new
      filter
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js {  }
      end
    end
  end

  private

  def pack_one
    @packed_item = PackedItem.new(
      item:       Item.find(params[:item]),
      packed_bag: PackedBag.find(params[:packed_bag])
    )
    if @packed_item.save
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(PackedBag.find(params[:packed_bag]),
        category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
        notice: "1 #{@packed_item.name} have been packed" }
        format.js { }
      end
    else
      flash[:alert] = 'Error: ' << 'Something went wrong'
      @packed_item = PackedItem.new
      @item = Item.new
      filter
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { }
      end
    end
  end

  def pack_many
    set_packed_bag # @packed_bag
    set_quantity   # @quantity
    @item          = Item.find(params[:packed_item][:item])
    @reference     = ItemReference.find(params[:packed_item][:reference].to_i)
    unpacked_items = @reference.unpacked_items(current_user, @packed_bag)
    if @quantity  <= unpacked_items.count
      @quantity.times do |i|
        @packed_item = PackedItem.new(
          item:       unpacked_items[i],
          packed_bag: @packed_bag
        )
        unless @packed_item.save
          flash[:alert] = 'Error: ' << 'Something went wrong'
          @packed_item  = PackedItem.new
          @item         = Item.new
          filter
        end
      end
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
          notice: "#{@quantity} #{@quantity > 1 ? @reference.name.pluralize : @reference.name} have been packed" }
        format.js { }
      end
    else
      flash[:alert] = 'Error: ' << "You can't pack more #{@reference.name.pluralize} than you own (#{unpacked_items.count})"
      @packed_item  = PackedItem.new
      @item         = Item.new
      filter
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { }
      end
    end
  end

  def pack_all
    set_packed_bag # @packed_bag
    current_user.items.each do |item|
      unless item.packed?(@packed_bag)
        @packed_item = PackedItem.new(
          item:       item,
          packed_bag: @packed_bag
        )
        @packed_item.save
      end
    end
    if current_user.items.count == @packed_bag.packed_items.count
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
          notice: "#{current_user.items.count} items have been packed" }
        format.js { }
      end
    else
      flash[:alert] = 'Error: ' << 'Something went wrong'
      @packed_item  = PackedItem.new
      @item         = Item.new
      filter
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { }
      end
    end
  end

  def unpack_one
    set_packed_item # @packed_item
    @packed_bag = @packed_item.packed_bag
    if @packed_item.destroy
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
          notice: "1 #{@packed_item.name} have been unpacked from the bag" }
        format.js { }
      end
    else
      flash[:alert] = 'Error: ' << @packed_item.errors.full_messages.join(' - ')
      @packed_item  = PackedItem.new
      @item         = Item.new
      filter
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { }
      end
    end
  end

  def unpack_many
    set_packed_item # @packed_item
    set_packed_bag  # @packed_bag
    set_quantity    # @quantity
    packed_items = @packed_bag.packed_items.select { |packed_item| packed_item.item.reference == @packed_item.item.reference }
    if @quantity <= packed_items.count
      @quantity.times do |i|
        @packed_item = packed_items[i]
        unless @packed_item.destroy
          flash[:alert] = 'Error: ' << 'Something went wrong'
          @packed_item  = PackedItem.new
          @item         = Item.new
          filter
        end
      end
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: @filter_on_category, direction: @filter_on_direction, group: @filter_on_group),
          notice: "#{@quantity} #{@quantity > 1 ? @packed_item.name.pluralize : @packed_item.name} have been unpacked from the bag" }
        format.js {  }
      end
    else
      flash[:alert] = 'Error: ' << "You can't unpack more #{@packed_item.name.pluralize} than you have packed (#{packed_items.count})"
      @packed_item  = PackedItem.new
      @item         = Item.new
      filter
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js {  }
      end
    end
  end

  def set_packed_item
    @packed_item = PackedItem.find(params[:id])
  end

  def set_packed_bag
    if params.key?(:packed_item)
      @packed_bag = PackedBag.find(params[:packed_item][:packed_bag])
    else
      @packed_bag = PackedBag.find(params[:packed_bag])
    end
  end

  def set_quantity
    @quantity = params[:packed_item][:quantity].to_i
  end

  def set_filters
    if params.key?(:packed_item)
      @filter_on_category  = params[:packed_item][:category_filter]
      @filter_on_direction = params[:packed_item][:direction_filter]
      @filter_on_group     = params[:packed_item][:group_filter]
    else
      @filter_on_category  = params[:category]
      @filter_on_direction = params[:direction]
      @filter_on_group     = params[:group]
    end
  end
end
