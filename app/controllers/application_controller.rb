class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def filter
    @categories        = ItemCategory.all
    @references        = ItemReference.all
    @owned_items       = current_user.items.order(created_at: :desc)
    @owned_references  = @owned_items.map { |item| item.reference }.uniq
    @packed_items      = @packed_bag.packed_items.order(created_at: :desc)
    @packed_references = @packed_items.map { |packed_item| packed_item.item.reference }.uniq
    if params.key?("category") &&  params[:category].to_i > 0
      category           = ItemCategory.find(params[:category])
      @references        = @references.select { |reference| reference.category == category }
      @owned_items       = @owned_items.select { |item| item.reference.category == category }
      @owned_references  = @owned_references.select { |reference| reference.category == category }
      @packed_items      = @packed_items.select { |packed_item| packed_item.item.reference.category == category }
      @packed_references = @packed_references.select { |reference| reference.category == category }
    end
  end
end
