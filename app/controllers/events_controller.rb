# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :find_event, only: %i[destroy update edit]

  def index
    @events = Event.all.order(:start_time).includes(:venue, :pictures_attachments)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to action: 'index', notice: 'Created successfully'
    else
      flash[:alert] = @event.errors.full_messages.to_s
      render :new
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to action: 'index', notice: 'Updated successfully'
    else
      flash[:alert] = @event.errors.full_messages.to_s
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to action: 'index', notice: 'Deleted successfully'
  end

  private

  def find_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :artist, :total_number_of_tickets,
                                  :start_time, :end_time, :venue_id,
                                  :ticket_price_currency, :ticket_price)
  end
end
