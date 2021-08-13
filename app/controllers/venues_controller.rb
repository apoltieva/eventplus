class VenuesController < ApplicationController
  load_and_authorize_resource
  before_action :find_venue, only: %i[destroy update edit]


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

  def edit; end

  def update
    if @venue.update(venue_params)
      redirect_to action: "index", notice: "Updated successfully"
    else
      flash[:alert] = "#{@venue.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    @venue.destroy
    redirect_to action: "index", notice: "Deleted successfully"
  end

  private

  def find_event
    @venue = Venue.find(params[:id])
  end

  def venue_params
    params.require(:venue).permit(:name, :latitude, :longitude)
  end
end
