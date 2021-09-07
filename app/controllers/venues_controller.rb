# frozen_string_literal: true

class VenuesController < ApplicationController
  load_and_authorize_resource
  before_action :find_venue, only: %i[destroy update edit]

  def index
    @venues = Venue.all.includes(pictures_attachments: :blob)
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      redirect_to action: 'index', notice: 'Created successfully'
    else
      flash[:alert] = @venue.errors.full_messages.join('; ')
      render :new
    end
  end

  def edit; end

  def update
    if @venue.update(venue_params)
      redirect_to action: 'index', notice: 'Updated successfully'
    else
      flash[:alert] = @venue.errors.full_messages.join('; ')
      render :edit
    end
  end

  def destroy
    if @venue.events.future.any? { |event| event.orders.any? }
      render json: { error: "You can't delete venues with future events that have tickets!" },
             status: :method_not_allowed
    else
      @venue.destroy
      render json: { id: @venue.id }
    end
  end

  private

  def find_venue
    @venue = Venue.find(params[:id])
  end

  def venue_params
    params.require(:venue).permit(:name, :latitude, :longitude, pictures: [])
  end
end
