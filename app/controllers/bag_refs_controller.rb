class BagRefsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @bag_refs = BagRef.all
  end

  def show
    @bag_ref = BagRef.find(params[:id])
    @new_bag = Bag.new
  end
end
