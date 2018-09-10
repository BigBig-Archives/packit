class ItemRefsController < ApplicationController

  def index
    @categories = ItemCategory.all
    @references = ItemRef.all
    @owned_items = current_user.items
    @owned_references = @owned_items.map { |item| item.reference }.uniq
    @owned_references.sort!
    @owned_categories = @owned_references.map { |reference| reference.category }.uniq
    @owned_categories.sort!
    @new_item = Item.new

    # Filters
    @filtered_by_category = false
    @filtered_by_owned = false
    @category_selected = nil
    @owned_selected = 0

    # Params filters
    if params.key?(:category)
      if params[:filtered_by_category].to_s == "true"
        @filtered_by_category = true
        @category_selected_id = params[:category].to_i # integer
        @category_selected = ItemCategory.find(@category_selected_id)
      else
        @filtered_by_category = false# instance
      end
    end
    if params.key?(:owned)
      @filtered_by_owned = true
      @filtered_by_owned = false if params[:owned].to_i.zero?
      @owned_selected = params[:owned].to_i # integer
    end
    if params.key?(:category) || params.key?(:owned)
      render :sort
    else
      render :index
    end
  end
end
