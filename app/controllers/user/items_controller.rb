class User::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_reference, only: %i[create destroy]

  def index
    @categories = ItemCategory.all
    @categories_displayed = ItemCategory.all
    @filter = 'all'
    @references = ItemRef.all
    @owned_items = current_user.items
    @owned_references = @owned_items.map { |item| item.reference }.uniq
    @owned_references.sort!
    @owned_categories = @owned_references.map { |reference| reference.category }.uniq
    @owned_categories.sort!
    @owned_categories_displayed = @owned_categories
    @owned_references_count = @owned_items.group(:reference_id).count
    @new_item = Item.new
    if params.key?(:category)
      unless params[:category] == 'all'
        @filter = ItemCategory.find(params[:category])
        @owned_categories_displayed = [@filter]
      end
      render :sort
    else
      render :index
    end
  end

  def create
    @item = Item.new
    @item.reference = @reference
    @item.user = current_user
    @item.save
    respond_to do |format|
      format.html { redirect_to item_refs_path }
      format.js
    end
  end

  def destroy
    item = @reference.items.where(user: current_user).last
    item.destroy
    respond_to do |format|
      format.html { redirect_to item_refs_path }
      format.js
    end
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
