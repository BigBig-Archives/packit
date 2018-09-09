class User::JourneysController < ApplicationController
  before_action :set_journey, only: %i[show update destroy]

  def index
    @journeys = current_user.journeys
    @new_journey = Journey.new
  end

  def show
    @bags = current_user.bags
    @packed_bags = current_user.packed_bags
    @bag_refs = BagRef.all
    @new_bag = Bag.new
  end

  def create
    @journey = Journey.new(journey_params)
    @journey.user = current_user
    @journey.save
  end

  def update
  end

  def destroy
    @journey.destroy
  end

  def set_journey
    @journey = Journey.find(params[:id])
  end

  def journey_params
    params.require(:journey).permit(
      :name,
      :start_date,
      :end_date,
      :category,
      :country,
      :city,
      :photo
    )
  end
end
