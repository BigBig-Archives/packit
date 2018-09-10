class User::PackedBagsController < ApplicationController
  before_action :set_packed_bag, only: %i[show update destroy]

  def show
    # @owned_items = current_user.items
    # @owned_references = @owned_items.map { |item| item.reference }.uniq
    # @owned_references.sort!
    # @owned_categories = @owned_references.map { |reference| reference.category }.uniq
    # @owned_categories.sort!
    # @new_item = Item.new

    # # Filters
    # @filtered_by_category = false
    # @category_selected = nil

    # # Params filters
    # if params.key?(:category)
    #   if params[:filtered_by_category].to_s == "true"
    #     @filtered_by_category = true
    #     @category_selected_id = params[:category].to_i # integer
    #     @category_selected = ItemCategory.find(@category_selected_id)
    #   else
    #     @filtered_by_category = false# instance
    #   end
    # end
    # if params.key?(:category)
    #   render :sort
    # else
    #   render :index
    # end
  end

  def create
    @packed_bag = PackedBag.new
    @packed_bag.bag = Bag.find(params[:bag])
    @packed_bag.save
    raise
    if @packed_bag.save
      respond_to do |format|
        format.html { redirect_to 'journeys/show', notice: 'Packed Bag created.' }
        format.js { render 'user/packed_bags/create' }
      end
    else
      respond_to do |format|
        format.html { redirect_to 'journeys/show', notice: 'Packed Bag not created.' }
        format.js { render 'user/packed_bags/create' }
      end
    end
  end

  def set_packed_bag
    @packed_bag = PackedBag.find(params[:id])
  end

  def packed_bag_params
    params.require(:packed_bag).permit(
      :name,
      :start_date,
      :end_date,
      :category,
      :country,
      :city,
      :photo
    )
  end
end
