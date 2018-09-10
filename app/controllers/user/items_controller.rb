class User::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_reference, only: %i[create destroy]

  def create
    @item = Item.new
    @item.reference = @reference
    @item.user = current_user
    @item.save
  end

  def destroy
    item = @reference.items.where(user: current_user).last
    item.destroy
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_reference
    @reference = ItemRef.find(params[:reference])
  end

  def item_params
    params.require(:item).permit(:custom_size, :custom_weight, :commentary)
  end
end
