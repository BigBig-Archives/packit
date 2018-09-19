class User::ItemsController < ApplicationController
  before_action :set_item, only: %i[update destroy]
  before_action :set_reference, only: %i[create]
  before_action :set_bag, only: %i[create update destroy]

  def create
    @item = Item.new(item_params)
    @item.reference = @reference
    @item.user = current_user
    if params[:item][:quantity].to_i > 0 && params[:item][:quantity].to_i <= 30 && @item.save
      params[:item][:quantity].to_i.-(1).times do
        @item = Item.new(item_params)
        @item.reference = @reference
        @item.user = current_user
        @item.save
        # how to check for errors here?
        # we guess that if first item of the list is saved, next items should too
      end
      filter
      respond_to do |format|
        format.html { redirect_to user_bag_path(@bag), notice: 'Item created' }
        format.js { render 'user/items/create' }
      end
    else
      @item.errors.add(:quantity, "should be greater than or equal to 1") if params[:item][:quantity].to_i < 1
      @item.errors.add(:quantity, "should be less than or equal to 30")   if params[:item][:quantity].to_i > 30
      @packed_item  = PackedItem.new
      filter
      flash[:alert] = 'Error: ' << @item.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/bags/show' }
        format.js { 'user/items/create' }
      end
    end
  end

  def update
    if @item.update(item_params)
      filter
      respond_to do |format|
        format.html { redirect_to user_bag_path(@bag), notice: 'Item updated'}
        format.js { render 'user/items/update' }
      end
    else
      @packed_item  = PackedItem.new
      filter
      flash[:alert] = 'Error: ' << @item.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/bags/show' }
        format.js { render 'user/items/update' }
      end
    end
  end

  def destroy
    if params.key?(:destroy_all) && params[:destroy_all] == 'true'
      # DESTROY ALL ITEMS FOR THIS REFERENCE
      @reference = @item.reference
      @count     = @reference.items.select { |item| item.user == current_user }.count
      if Item.where(reference: @reference, user: current_user).destroy_all
        filter
        respond_to do |format|
          format.html { redirect_to user_bag_path(@bag),
            notice:   "#{@count} #{@count > 1 ? @reference.name.pluralize : @reference.name} have been destroyed" }
          format.js { render 'user/items/destroy' }
        end
      else
        flash[:alert] = 'Error: ' << 'Something went wrong'
        filter
        respond_to do |format|
          format.html { render 'user/bag/show' }
          format.js { render 'user/items/destroy' }
        end
      end
    else
      # DESTROY ONE ITEM
      item_name = @item.name
      if @item.destroy
        filter
        respond_to do |format|
          format.html { redirect_to user_pbag_path(@bag), notice:   "1 #{item_name} destroyed" }
          format.js { render 'user/items/destroy' }
        end
      else
        filter
        flash[:alert] = 'Error: ' << @item.errors.full_messages.join(' - ')
        respond_to do |format|
          format.html { render 'user/bag/show' }
          format.js { render 'user/items/destroy' }
        end
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

  def set_bag
    if params.key?(:item)
      @bag = Bag.find(params[:item][:bag])
    else
      @bag = Bag.find(params[:bag])
    end
  end

  def item_params
    params.require(:item).permit(:size, :weight)
  end
end
