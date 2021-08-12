class VenuesController < ApplicationController
  before_action :authenticate_user!

  def index
    @venues = Venue.all.includes(:pictures_attachments)
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      redirect_to action: "index", notice: "Created successfully"
    else
      flash[:alert] = "#{@venue.errors.full_messages}"
      render :new
    end
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])
    if @venue.update(venue_params)
      redirect_to action: "index", notice: "Updated successfully"
    else
      flash[:alert] = "#{@venue.errors.full_messages}"
      render :edit
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
