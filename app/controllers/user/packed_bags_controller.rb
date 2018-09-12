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
    if @packed_bag.save
      respond_to do |format|
        format.html { redirect_to user_packed_bag_path(@packed_bag), notice: 'Packed Bag created' }
        format.js { render 'user/packed_bags/create' }
      end
    else
      @bag = Bag.new
      @templates = BagTemplate.all
      flash[:alert] = 'Error: ' << @packed_bag.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/journeys/show' }
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
        flash[:alert] = 'Error: ' << @copy.errors.full_messages.join(' - ')
        respond_to do |format|
          format.html { redirect_to user_journey_path(@journey) }
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
      flash[:alert] = 'Error: ' << @packed_bag.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { redirect_to user_journey_path(@journey) }
        format.js { render 'user/packed_bags/destroy' }
      end
    end
  end

  private

  def set_packed_bag
    @packed_bag = PackedBag.find(params[:id])
  end

  def packed_bag_params
    params.require(:packed_bag).permit(:name, :bag_id)
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
