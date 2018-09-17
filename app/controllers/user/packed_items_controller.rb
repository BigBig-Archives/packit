class User::PackedItemsController < ApplicationController

  def create
    set_packed_bag # @packed_bag

    # PACK ONE ITEM
    if params.key?(:pack) && params[:pack] == 'one'
      @packed_item = PackedItem.new(
        item:       Item.find(params[:item]),
        packed_bag: @packed_bag
      )
      if @packed_item.save
        filter
        respond_to do |format|
          format.html { redirect_to user_packed_bag_path(PackedBag.find(params[:packed_bag])),
          notice: "1 #{@packed_item.name} have been packed" }
          format.js { render 'user/packed_items/create' }
        end
      else
        flash[:alert] = 'Error: ' << 'Something went wrong'
        @packed_item = PackedItem.new
        @item = Item.new
        filter
        respond_to do |format|
          format.html { render 'user/packed_bags/show' }
          format.js { render 'user/packed_items/create' }
        end
      end

    # PACK MANY ITEMS OWNED OF A REFERENCE
    elsif params.key?(:packed_item) && params[:packed_item][:pack] == 'many'
      @quantity      = params[:packed_item][:quantity].to_i
      @item          = Item.find(params[:packed_item][:item])
      @reference     = @item.reference
      unpacked_items = @reference.unpacked_items(current_user, @packed_bag)
      @packed_item = PackedItem.new(
        item:       unpacked_items.first,
        packed_bag: @packed_bag
      )
      if @quantity <= unpacked_items.count && @quantity > 0 && @packed_item.save
        (@quantity - 1).times do |i|
          @packed_item = PackedItem.new(
            item:       unpacked_items[i + 1],
            packed_bag: @packed_bag
          )
          @packed_item.save
        end
        filter
        @packed_item = PackedItem.new
        respond_to do |format|
          format.html { redirect_to user_packed_bag_path(@packed_bag),
            notice: "#{@quantity} #{@quantity > 1 ? @item.reference.name.pluralize : @item.reference.name} have been packed" }
          format.js { render 'user/packed_items/create' }
        end
      else
        flash[:alert] = 'Error: ' << "You can't pack more #{@item.reference.name.pluralize} than you own (#{unpacked_items.count})"
        @packed_item.errors.add(:quantity, "should be greater than or equal to 1") if @quantity < 1
        @packed_item.errors.add(:quantity, "should be less than items not already packed") if @quantity > unpacked_items.count
        @item = Item.new
        filter
        respond_to do |format|
          format.html { render 'user/packed_bags/show' }
          format.js { render 'user/packed_items/create' }
        end
      end

    # PACK ALL ITEMS OWNED
    elsif params.key?(:pack) && params[:pack] == 'all'
      @count = 0
      current_user.items.each do |item|
        unless item.packed?(@packed_bag)
          @packed_item = PackedItem.new(
            item:       item,
            packed_bag: @packed_bag
          )
          @packed_item.save
          @count += 1
        end
      end
      if current_user.items.count == @packed_bag.packed_items.count
        filter
        respond_to do |format|
          format.html { redirect_to user_packed_bag_path(@packed_bag), notice: "#{@count} items have been packed" }
          format.js { render 'user/packed_items/create' }
        end
      else
        flash[:alert] = 'Error: ' << 'Something went wrong'
        @packed_item  = PackedItem.new
        @item         = Item.new
        filter
        respond_to do |format|
          format.html { render 'user/packed_bags/show' }
          format.js { render 'user/packed_items/create' }
        end
      end

    # ERROR
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

  def update
    set_packed_bag # @packed_bag

    @reference = ItemReference.find(params[:packed_item][:reference])
    @packed_items = @packed_bag.packed_items.select { |packed_item| packed_item.item.reference == @reference }
    @packed_item = @packed_items.first
    @quantity = params[:packed_item][:quantity].to_i
    if @quantity <= @packed_items.count && @quantity > 0 && @packed_items[0].destroy
      (@quantity - 1).times do |i|
        @packed_items[i + 1].destroy
      end
      filter
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag),
          notice: "#{@quantity} #{@quantity > 1 ? @reference.name.pluralize : @reference.name} have been unpacked from the bag" }
        format.js { render 'user/packed_items/destroy' }
      end
    else
      flash[:alert] = 'Error: ' << "You can't unpack more #{@reference.name.pluralize} than you have packed (#{@packed_items.count})"
      @packed_item.errors.add(:quantity, "should be greater than or equal to 1") if @quantity < 1
      @packed_item.errors.add(:quantity, "should be less than items packed") if @quantity > @packed_items.count
      @item = Item.new
      filter
      respond_to do |format|
        format.html { render 'user/packed_bags/show' }
        format.js { render 'user/packed_items/destroy' }
      end
    end
  end

  def destroy
    set_packed_item # @packed_item
    @packed_item_name = @packed_item.name
    @packed_bag = @packed_item.packed_bag

    # UNPACK ON PACKED ITEM
    if params[:unpack] == 'one'
      if @packed_item.destroy
        filter
        respond_to do |format|
          format.html { redirect_to user_packed_bag_path(@packed_bag), notice: "1 #{@packed_item_name} have been unpacked from the bag" }
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

    # UNPACK ALL PACKED ITEMS OF A REFERENCE
    if params[:unpack] == 'all'
      @count = @packed_bag.packed_items.count
      if @packed_bag.packed_items.destroy_all
        @packed_item  = PackedItem.new
        filter
        respond_to do |format|
          format.html { redirect_to user_packed_bag_path(@packed_bag), notice: "All the #{@count} items have been unpacked from the bag" }
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
  end

  private

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
end
