class ItemRefsController < ApplicationController

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
    @owned_references_count = @owned_items.group(:reference_id).count
    @new_item = Item.new
    if params.key?(:category)
      unless params[:category] == 'all'
        @filter = ItemCategory.find(params[:category])
        @categories_displayed = [@filter]
      end
      render :sort
    else
      render :index
    end
  end
end
