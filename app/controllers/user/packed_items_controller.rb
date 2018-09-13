class User::PackedItemsController < ApplicationController

  def create
    if params.key?(:packed_item) && params[:packed_item][:pack_all] == 'true'
      pack_many
    else
      pack_one
    end
  end

  def update
    if params.key?(:packed_item) && params[:packed_item][:pack_all] == 'true'
      unpack_many
    else
      unpack_one
    end
  end

  private

  def pack_one
    @packed_bag = PackedBag.find(params[:packed_bag])
    @item = Item.find(params[:item])
    @packed_item = PackedItem.new
    @packed_item.packed_bag = @packed_bag
    @packed_item.item = @item
    if @packed_item.save
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: params[:category],
          display: params[:display],
          group: params[:group]),
          notice: "1 #{@packed_item.name} have been packed" }
        format.js { }
      end
    else
      @packed_item  = PackedItem.new
      @item         = Item.new
      set_filters
      flash[:alert] = 'Error: ' << @packed_item.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { }
      end
    end
  end

  def pack_many
    @item = Item.find(params[:packed_item][:item])
    @packed_bag   = PackedBag.find(params[:packed_item][:packed_bag])
    @reference = ItemReference.find(params[:packed_item][:reference].to_i)
    unpacked_items = @reference.unpacked_items(current_user, @packed_bag)
    quantity = params[:packed_item][:quantity].to_i
    if quantity  <= unpacked_items.count
      quantity.times do |i|
        @packed_item = PackedItem.new
        @packed_item.packed_bag = @packed_bag
        @packed_item.item = unpacked_items[i]
        unless @packed_item.save
          @packed_item.errors.add(:quantity, "Something went wrong")
          @packed_item  = PackedItem.new
          @item         = Item.new
          set_filters
          flash[:alert] = 'Error: ' << 'Something went wrong'
        end
      end
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: params[:packed_item][:category_filter],
          display: params[:packed_item][:display_filter],
          group: params[:packed_item][:group_filter]),
          notice: "#{quantity} #{quantity > 1 ? @reference.name.pluralize : @reference.name} have been packed" }
        format.js { }
      end
    else
      @packed_item  = PackedItem.new
      @item         = Item.new
      set_filters
      flash[:alert] = 'Error: ' << "You can't pack more #{@reference.name.pluralize} than you own"
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { render '' }
      end
    end
  end

  def unpack_one
    @packed_item = PackedItem.find(params[:id])
    @packed_bag = @packed_item.packed_bag
    if @packed_item.destroy
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: params[:packed_item][:category_filter],
          display: params[:packed_item][:display_filter],
          group: params[:packed_item][:group_filter]),
          notice: "1 #{@packed_item.name} have been unpacked from the bag" }
        format.js { render '' }
      end
    else
      @packed_item  = PackedItem.new
      @item         = Item.new
      set_filters
      flash[:alert] = 'Error: ' << @packed_item.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { render '' }
      end
    end
  end

  def unpack_many
    @packed_item = PackedItem.find(params[:id])
    @packed_bag = PackedBag.find(params[:packed_item][:packed_bag])
    quantity = params[:packed_item][:quantity].to_i
    packed_items = @packed_bag.packed_items.select { |packed_item| packed_item.item.reference == @packed_item.item.reference }
    if quantity <= packed_items.count
      quantity.times do |i|
        @packed_item = packed_items[i]
        unless @packed_item.destroy
          @packed_item.errors.add(:quantity, "Something went wrong")
        end
      end
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: params[:packed_item][:category_filter],
          display: params[:packed_item][:display_filter],
          group: params[:packed_item][:group_filter]),
          notice: "#{quantity} #{quantity > 1 ? @packed_item.name.pluralize : @packed_item.name} have been unpacked from the bag" }
        format.js { render '' }
      end
    else
      @packed_item.errors.add(:quantity, "You can't unpack more items than you have packed")
      @packed_item.errors.add(:quantity, "Something went wrong")
      @item         = Item.new
      set_filters
      flash[:alert] = 'Error: ' << @packed_item.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { render '' }
      end
    end
  end
end
