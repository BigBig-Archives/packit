class User::BagsController < ApplicationController
  before_action :set_bag, only: %i[show update destroy copy]
  before_action :set_filters, only: :show

  def index
    @scroll = true
    @bags = Bag.all
    @bag = Bag.new
  end

  def show
    @scroll = false
    @packed_item = PackedItem.new
    @item        = Item.new
    filter
    respond_to do |format|
      format.html { render 'show' }
      format.js { render 'user/bags/show' }
    end
  end

  def create
    @bag = Bag.new(bag_params)
    @bag.user = current_user
    if @bag.save
      respond_to do |format|
        format.html { redirect_to user_bag_path(@bag), notice: 'Bag created' }
        format.js { render 'user/bags/create' }
      end
    else
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/bags/index' }
        format.js { render 'user/bags/create' }
      end
    end
  end

  def copy
    @copy = Bag.new
    @copy.name    = @bag.name << ' - copy'
    if @copy.save
      @bag.packed_items.each do |packed_item|
        @packed_item = PackedItem.new
        @packed_item.bag = @copy
        @packed_item.item       = packed_item.item
        @packed_item.save
      end
      if @bag.packed_items.count == @copy.packed_items.count
        respond_to do |format|
          format.html { redirect_to user_bag_path(@copy), notice: 'Bag copied' }
        end
      else
        flash[:alert] = 'Error: ' << @copy.errors.full_messages.join(' - ')
        @bag = Bag.new
        respond_to do |format|
          format.html { render 'user/bags/index' }
        end
      end
    else
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      @bag = Bag.new
      respond_to do |format|
        format.html { render 'user/bags/index' }
      end
    end
  end

  def destroy
    if @bag.destroy
      respond_to do |format|
        format.html { redirect_to user_bags_path, notice: 'Bag destroyed.' }
        format.js { render 'user/bags/destroy' }
      end
    else
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      @bag = Bag.new
      respond_to do |format|
        format.html { render 'user/bags/index' }
        format.js { render 'user/bags/destroy' }
      end
    end
  end

  private

  def set_bag
    @bag = Bag.find(params[:id])
  end

  def bag_params
    params.require(:bag).permit(:name, :capacity, :picture)
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
