class User::BagsController < ApplicationController
  before_action :set_bag, only: %i[update destroy]
  before_action :set_reference, only: %i[create]

  def index
    @bags = current_user.bags
  end

  def create
    @bag = Bag.new(bag_params)
    @bag.user = current_user
    @bag.custom_size = @bag_ref.size if @bag.custom_size.nil?
    @bag.custom_capacity = @bag_ref.capacity if @bag.custom_capacity.nil?
    @bag.custom_weight = @bag_ref.weight if @bag.custom_weight.nil?
    @bag.save
  end

  def destroy
    respond_to do |format|
      if @bag.destroy
        format.html { redirect_to 'journeys/show', notice: 'Bag was successfully destroyed.' }
        format.js
      else
        format.js { render :error }
      end
    end
  end

  private

  def set_bag
    @bag = Bag.find(params[:id])
  end

  def set_reference
    @bag_ref = BagRef.find(params[:bag][:reference_id])
  end

  def bag_params
    params.require(:bag).permit(:reference_id, :name, :custom_size, :custom_capacity, :custom_weight)
  end
end
