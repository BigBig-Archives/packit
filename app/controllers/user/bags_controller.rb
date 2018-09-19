class User::BagsController < ApplicationController
  before_action :set_bag, only: %i[show update destroy copy]
  before_action :set_filters, only: :show

  def index
    @scroll = true
    @new_bag = Bag.new
  end

  def show
    @scroll = false
    @packed_item = PackedItem.new
    @item        = Item.new
    filter
    respond_to do |format|
      format.html { render 'show' }
      format.js { render 'user/bags/show.js.erb' }
    end
  end

  def create
    @bag = Bag.new(bag_params)
    @bag.user = current_user
    if @bag.save
      respond_to do |format|
        format.html { redirect_to user_bags_path, notice: 'Bag created' }
        format.js { render 'user/bags/create' }
      end
    else
      @scroll = true
      @new_bag = Bag.new
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/bags/index' }
        format.js { render 'user/bags/create' }
      end
    end
  end

  def update
    if @bag.update(bag_params)
      filter
      respond_to do |format|
        format.html { redirect_to user_bags_path, notice: 'Bag updated'}
        format.js { render 'user/bags/update' }
      end
    else
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      @scroll = true
      @new_bag = Bag.new
      respond_to do |format|
        format.html { render 'user/bags/index' }
        format.js { render 'user/bags/update' }
      end
    end
  end

  def copy
    @copy = Bag.new(capacity: @bag.capacity, picture: @bag.picture)
    @copy.name = @bag.name << ' - copy'
    @copy.user = current_user
    if @copy.save
      @bag.packed_items.each do |packed_item|
        @packed_item = PackedItem.new(bag: @copy, item: packed_item.item)
        @packed_item.save
      end
      if @bag.packed_items.count == @copy.packed_items.count
        respond_to do |format|
          format.html { redirect_to user_bags_path, notice: 'Bag copied' }
          format.js { render 'user/bags/copy' }
        end
      else
        flash[:alert] = 'Error: ' << @copy.errors.full_messages.join(' - ')
        @scroll = true
        @new_bag = Bag.new
        @bag  = Bag.new
        respond_to do |format|
          format.html { render 'user/bags/index' }
          format.js { render 'user/bags/copy' }
        end
      end
    else
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      @scroll = true
      @new_bag = Bag.new
      @bag  = Bag.new
      respond_to do |format|
        format.html { render 'user/bags/index' }
        format.js { render 'user/bags/copy' }
      end
    end
  end

  def destroy
    @bag_id = @bag.id
    if @bag.destroy
      respond_to do |format|
        format.html { redirect_to user_bags_path, notice: 'Bag destroyed.' }
        format.js { render 'user/bags/destroy' }
      end
    else
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      @scroll = true
      @new_bag = Bag.new
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
