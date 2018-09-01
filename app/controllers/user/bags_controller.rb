class User::BagsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_bag, only: %i[create]

  def index
    @bags = Bag.all
  end

  def create
    @bag = UserBag.new(bag_params)
    @bag.user = current_user
    @bag.bag = @bag
    @bag.custom_size = @bag.size if @bag.custom_size.nil?
    @bag.custom_capacity = @bag.capacity if @bag.custom_capacity.nil?
    @bag.custom_weight = @bag.weight if @bag.custom_weight.nil?
    if @bag.save
      redirect_to user_bags_path
    else
      render 'bags/show'
    end
  end

  private

  def set_bag
    @bag = UserBag.find(params[:id])
  end

  def set_bag
    @bag = Bag.find(params[:bag][:bag_id])
  end

  def bag_params
    params.require(:bag).permit(:custom_size, :custom_capacity, :custom_weight)
  end
end
