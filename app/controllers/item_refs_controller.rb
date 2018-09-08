class ItemRefsController < ApplicationController

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
    if params.key?(:category)
      @category = ItemCategory.find(params[:category])
      render :sort
    else
      render :index
    end
  end

  def sort
  end

  def show; end

  def create; end

  def update; end

  def destroy; end
end
