class User::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_item_ref, only: %i[create]

  def index
    @user_items = current_user.items
    @item_refs = @user_items.map { |item| item.item_ref }.uniq
    @item_refs.sort!
    @categories = @item_refs.map { |item_ref| item_ref.category }.uniq
    @categories.sort!
    @item_refs_count = @user_items.group(:item_ref_id).count
  end

  def show; end

  def create
    @item = Item.new(item_params)
    @item.user = current_user
    if @item.save
      redirect_to user_items_path
    else
      render 'items/show'
    end
  end

  def update
    raise
  end

  def destroy
    if @item.destroy
      redirect_to user_items_path
    else
      render index
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
