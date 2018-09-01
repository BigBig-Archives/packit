class ItemRefsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @item_refs = ItemRef.all
  end

  def show
    @item_ref = ItemRef.find(params[:id])
    @new_item = Item.new
  end
end
