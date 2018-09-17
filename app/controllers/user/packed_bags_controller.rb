class User::PackedBagsController < ApplicationController
  before_action :set_packed_bag, only: %i[show update destroy copy]
  before_action :set_filters, only: :show

  def show
    @packed_item = PackedItem.new
    @item        = Item.new
    filter
    respond_to do |format|
      format.html { render 'show' }
      format.js { render 'user/packed_bags/show' }
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
      flash[:alert] = 'Error: ' << @packed_bag.errors.full_messages.join(' - ')
      @bag = Bag.new
      @templates = BagTemplate.all
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
        flash[:alert] = 'Error: ' << @copy.errors.full_messages.join(' - ')
        @templates = BagTemplate.all
        @bag = Bag.new
        @packed_bag = PackedBag.new
        respond_to do |format|
          format.html { redirect_to user_journey_path(@journey) }
        end
      end
    else
      flash[:alert] = 'Error: ' << @packed_bag.errors.full_messages.join(' - ')
      @templates = BagTemplate.all
      @bag = Bag.new
      @packed_bag = PackedBag.new
      respond_to do |format|
        format.html { redirect_to user_journey_path(@journey) }
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
      flash[:alert] = 'Error: ' << @packed_bag.errors.full_messages.join(' - ')
      @templates = BagTemplate.all
      @bag = Bag.new
      @packed_bag = PackedBag.new
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
    session[:category]   = params[:category] if params[:category]
    session[:category]   = '0' if session[:category].nil?
    session[:display]    = params[:display] if params[:display]
    session[:display]    = 'group' if session[:display].nil?
    session[:operation]  = params[:operation] if params[:operation]
    session[:operation]  = 'create' if session[:operation].nil?


    session[:category_name] = ItemCategory.find(session[:category].to_i).name unless session[:category].to_i.zero?
  end
end
