class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_url_params

  def filter
    @categories        = ItemCategory.all
    @references        = ItemReference.all
    @owned_items       = current_user.items.order(created_at: :desc)
    @owned_references  = @owned_items.map { |item| item.reference }.uniq
    @packed_items      = @packed_bag.packed_items.order(created_at: :desc)
    @packed_references = @packed_items.map { |packed_item| packed_item.item.reference }.uniq
    if params.key?(:cat) &&  params[:cat].to_i > 0
      category           = ItemCategory.find(@cat)
      @references        = @references.select { |reference| reference.category == category }
      @owned_items       = @owned_items.select { |item| item.reference.category == category }
      @owned_references  = @owned_references.select { |reference| reference.category == category }
      @packed_items      = @packed_items.select { |packed_item| packed_item.item.reference.category == category }
      @packed_references = @packed_references.select { |reference| reference.category == category }
    end
  end

  def set_url_params

    @cat = params[:cat]
    @ope = params[:ope]
    @dis = params[:dis]

    if @cat.nil? && params.key?(:item)
      @cat = params[:item][:cat]
      @ope = params[:item][:ope]
      @dis = params[:item][:dis]
    end

    if @cat.nil? && params.key?(:packed_item)
      @cat = params[:packed_item][:cat]
      @ope = params[:packed_item][:ope]
      @dis = params[:packed_item][:dis]
    end
  end
end
