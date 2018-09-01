class User::BagsController < ApplicationController
  before_action :set_bag_ref, only: %i[create]

  def index
    @bags = current_user.bags
  end

  def create
    @bag = Bag.new(bag_params)
    @bag.user = current_user
    @bag.custom_size = @bag_ref.size if @bag.custom_size.nil?
    @bag.custom_capacity = @bag_ref.capacity if @bag.custom_capacity.nil?
    @bag.custom_weight = @bag_ref.weight if @bag.custom_weight.nil?
    if @bag.save
      redirect_to user_bags_path
    else
      render 'bags/show'
    end
  end

  private

  def set_bag
    @bag = Bag.find(params[:id])
  end

  def set_bag_ref
    @bag_ref = BagRef.find(params[:bag][:bag_ref_id])
  end

  def bag_params
    params.require(:bag).permit(:bag_ref_id, :custom_size, :custom_capacity, :custom_weight)
  end
end
