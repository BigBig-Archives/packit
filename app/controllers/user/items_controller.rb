class User::ItemsController < ApplicationController
  before_action :set_item_ref, only: %i[create]

  def index
    @items = current_user.items
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user
    @item.custom_size = @item_ref.size if @item.custom_size.nil?
    @item.custom_weight = @item_ref.weight if @item.custom_weight.nil?
    if @item.save
      redirect_to user_items_path
    else
      render 'items/show'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_item_ref
    @item_ref = ItemRef.find(params[:item][:item_ref_id])
  end

  def item_params
    params.require(:item).permit(:item_ref_id, :custom_size, :custom_weight, :commentary)
  end
end
