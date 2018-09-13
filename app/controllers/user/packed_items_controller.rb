class User::PackedItemsController < ApplicationController
  before_action :set_packed_item, only: %i[update destroy]
  before_action :set_item, only: %i[create]
  before_action :set_packed_bag, only: %i[create update]
  before_action :set_reference, only: %i[create]

  def create
    if params.key?(:packed_item) && params[:packed_item][:pack_all] == 'true'
      create_many
    else
      create_one
    end
  end

  def update
    unpack_many
  end

  def destroy
    @packed_bag = @packed_item.packed_bag
    if @packed_item.destroy
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: params[:category],
          display: params[:display],
          group: params[:group]),
          notice: 'Packed item destroyed.' }
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

  private

  def set_packed_item
    @packed_item = PackedItem.find(params[:id])
  end

  def set_item
    if params.key?(:item) # pack one
      @item = Item.find(params[:item])
    else # pack many
      @item = Item.find(params[:packed_item][:item])
    end
  end

  def set_packed_bag
    if params.key?(:packed_bag) # pack one
      @packed_bag = PackedBag.find(params[:packed_bag])
    else # pack many
      @packed_bag = PackedBag.find(params[:packed_item][:packed_bag])
    end
  end

  def set_reference
    @reference = ItemReference.find(params[:packed_item][:reference].to_i)
  end

  def create_one
    @packed_item = PackedItem.new
    @packed_item.packed_bag = @packed_bag
    @packed_item.item = @item
    if @packed_item.save
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag,
          category: params[:category],
          display: params[:display],
          group: params[:group]),
          notice: 'Packed item created.' }
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

  def create_many
    unpacked_items = @reference.unpacked_items(current_user, @packed_bag)
    # quantity = params[:packed_item][:quantity].to_i
    # all items owned for this reference
    # owned = current_user.items.select { |item| item.reference == @item.reference }
    # all items packed for this reference in this bag
    # packed = @packed_bag.items.select { |item| item.reference == @item.reference }
    # all items unpacked for this reference in this bag
    # unpacked_items = owned - packed
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
          flash[:alert] = 'Error: ' << @packed_item.errors.full_messages.join(' - ')
          respond_to do |format|
            format.html { render 'user/packed_bags/show' }
            format.js { render '' }
          end
        end
      end
    else
      @packed_item.errors.add(:quantity, "You can't pack more items than you own")
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
    if params.key?(:packed_item) && params[:packed_item][:pack_all] == 'true'
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
            category: params[:category],
            display: params[:display],
            group: params[:group]),
            notice: 'Packed item destroyed.' }
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

  def set_filters
    @categories        = ItemCategory.all
    @references        = ItemReference.all
    @owned_items       = current_user.items.order(created_at: :desc)
    @owned_references  = current_user.references.order(created_at: :desc).uniq
    @packed_items      = @packed_bag.packed_items.order(created_at: :desc)
    @packed_references = @packed_items.map { |packed_item| packed_item.item.reference }.uniq
    if params.key?("category") &&  params[:category].to_i > 0
      category           = ItemCategory.find(params[:category])
      @references        = @references.select { |reference| reference.category == category }
      @owned_items       = @owned_items.select { |item| item.reference.category == category }
      @owned_references  = @owned_references.select { |reference| reference.category == category }
      @packed_items      = @packed_items.select { |packed_item| packed_item.item.reference.category == category }
      @packed_references = @packed_references.select { |reference| reference.category == category }
    end
    @group = false
    if params.key?("group") && params[:group] == 'true'
      @group = true
    end
  end

end
