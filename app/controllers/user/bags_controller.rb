class User::BagsController < ApplicationController
  before_action :set_bag, only: %i[update destroy]
  before_action :set_reference, only: :create
  before_action :set_journey, only: %i[create update destroy]

  def create
    @bag = Bag.new(bag_params)
    @bag.name = @template.name if @bag.name.nil? # use template value
    @bag.capacity = @template.capacity if @bag.capacity.nil? # use template value
    @bag.picture = @template.picture if @bag.picture.nil? # use template value
    @bag.user = current_user
    if @bag.save
      respond_to do |format|
        format.html { redirect_to user_journey_path(@journey), notice: 'Bag created.' }
        format.js { render 'user/bags/create' }
      end
    else
      @templates = BagTemplate.all
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/journeys/show' }
        format.js { render 'user/bags/create' }
      end
    end
  end

  def update
    if @bag.update(bag_params)
      respond_to do |format|
        format.html { redirect_to user_journey_path(@journey), notice: 'bag updated.' }
        format.js { }
      end
    else
      @templates = BagTemplate.all
      @packed_bag = PackedBag.new
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/journeys/show' }
        format.js { }
      end
    end
  end

  def destroy
    if @bag.destroy
      respond_to do |format|
        format.html { redirect_to user_journey_path(@journey), notice: 'Bag destroyed.' }
        format.js { render 'user/bags/destroy' }
      end
    else
      @templates = BagTemplate.all
      @bag = Bag.new
      flash[:alert] = 'Error: ' << @bag.errors.full_messages.join(' - ')
      respond_to do |format|
        format.html { render 'user/journeys/show' }
        format.js { render 'user/bags/destroy' }
      end
    end
  end

  private

  def set_bag
    @bag = Bag.find(params[:id])
  end

  def set_reference
    @template = BagTemplate.find(params[:bag][:template])
  end

  def set_journey
    if params.key?(:bag)
      @journey = Journey.find(params[:bag][:journey]) # from form
    else
      @journey = Journey.find(params[:journey]) # from button_to
    end
  end

  def bag_params
    params.require(:bag).permit(:name, :capacity, :picture)
  end
end
