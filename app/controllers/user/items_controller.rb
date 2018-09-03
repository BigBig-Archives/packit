class User::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_item_ref, only: %i[create]

  def index
    @categories = ItemCategory.all
    @references = ItemRef.all
    @owned_items = current_user.items
    @owned_references = @owned_items.map { |item| item.reference }.uniq
    @owned_references.sort!
    @owned_categories = @owned_references.map { |reference| reference.category }.uniq
    @owned_categories.sort!
    @owned_references_count = @owned_items.group(:reference_id).count
    @new_item = Item.new
  end

  def show; end

  def create
    @item = Item.new(item_params)
    @item.user = current_user
    if @item.save
      respond_to do |format|
        format.html { redirect_to user_items_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { render_index }
        format.js
      end
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
    @item_ref = ItemRef.find(params[:item][:reference_id])
  end

  def item_params
    params.require(:item).permit(:reference_id, :custom_size, :custom_weight, :commentary)
  end

  def render_index
    @categories = ItemCategory.all
    @references = ItemRef.all
    @owned_items = current_user.items
    @owned_references = @owned_items.map { |item| item.reference }.uniq
    @owned_references.sort!
    @owned_categories = @owned_references.map { |reference| reference.category }.uniq
    @owned_categories.sort!
    @owned_references_count = @owned_items.group(:reference_id).count
    @new_item = Item.new
    render 'user/items/index'
  end
end
