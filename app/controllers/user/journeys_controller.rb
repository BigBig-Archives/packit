class User::JourneysController < ApplicationController
  before_action :set_journey, only: %i[show update destroy]

  def index
    @journey = Journey.new
  end

  def show
    @references = BagRef.all
    @bag = Bag.new
  end

  def create
    @journey = Journey.new(journey_params)
    @journey.user = current_user
    if @journey.save
      respond_to do |format|
        format.html { redirect_to user_journeys_path }
        format.js { render 'user/journeys/create' }
      end
    else
      respond_to do |format|
        format.html { render :index }
        format.js { render 'user/journeys/create' }
      end
    end
  end

  def update
  end

  def destroy
    if @journey.destroy
      respond_to do |format|
        format.html { redirect_to user_journeys_path }
        format.js { render 'user/journeys/destroy' }
      end
    else
      @journey = Journey.new
      respond_to do |format|
        format.html { render :index }
        format.js { render 'user/journeys/destroy' }
      end
    end
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
