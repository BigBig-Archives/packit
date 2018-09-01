class BagsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @bags = Bag.all
  end

  def show
    @bag = Bag.find(params[:id])
  end
end
