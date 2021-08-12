class VenuesController < ApplicationController
  before_action :authenticate_user!

  def index
    @venues = Venue.all
  end

  def new
    @user = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      render :index, notice: "Created successfully"
    else
      render :new, notice: "#{@venue.errors.full_messages}"
    end
  end

  def update
    @venue = Venue.find(params[:id])
    if @venue.update(venue_params)
      render :index, notice: "Updated successfully"
    else
      render :new, notice: "#{@venue.errors.full_messages}"
    end
  end

  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :latitude, :longitude)
  end
end
