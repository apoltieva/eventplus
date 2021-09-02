# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :find_event, only: %i[destroy update edit show]

  def current_user
    @current_user ||= super.tap do |user|
      ::ActiveRecord::Associations::Preloader.new.preload(user, :events)
    end
  end

  def index
    @events = case params[:filter]
              when 'user'
                User.find(current_user.id).events.where('end_time > ?', Time.now).order(:start_time)
              when 'user_past'
                User.find(current_user.id).events.where('end_time <= ?',
                                                        Time.now).order(:start_time)
              when 'past'
                Event.where('end_time <= ?', Time.now).order(:start_time)
              when 'nearest'
                location = if !request.remote_ip || request.remote_ip == '127.0.0.1'
                             'Kiev, Ukraine'
                           else
                             request.safe_location
                           end
                Event.where(venue: Venue.near(location, 900_000, order: 'distance').map(&:id))
              else
                Event.all.order(:start_time)
              end
    @events = @events.includes(:venue, pictures_attachments: :blob)
                     .paginate(page: params[:page], per_page: 2)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @event = Event.new
  end

  def show
    ActiveRecord::Associations::Preloader.new.preload(@event, [{ pictures_attachments: :blob },
                                                               { venue:
                                                                   { pictures_attachments: :blob } }])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to action: 'index', notice: 'Created successfully'
    else
      flash[:alert] = @event.errors.full_messages.join('; ')
      render :new
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to action: 'index', notice: 'Updated successfully'
    else
      flash[:alert] = @event.errors.full_messages.join('; ')
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
                                  :ticket_price_currency, :ticket_price, pictures: [])
  end
end
