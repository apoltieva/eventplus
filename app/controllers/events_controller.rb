# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :find_event, only: %i[destroy update edit show]

  def current_user
    @current_user ||= super.tap do |user|
      ::ActiveRecord::Associations::Preloader.new.preload(user, :events)
    end
  end

  def index
    # location = request.safe_location || 'Kiev, Ukraine'
    location = if !request.remote_ip || request.remote_ip == '127.0.0.1'
                 'Kiev, Ukraine'
               else
                 request.safe_location
               end
    if current_user
      id = current_user.id
      @events_num_of_tickets = current_user.orders.group(:event_id).sum(:quantity)
    else
      @events_num_of_tickets = {}
    end
    @events = if params[:filter] == 'nearest'
                coords = Geocoder.search(location).first.coordinates
                @venues_with_distance = Venue.near(
                  coords, 20_000, units: :km, select: 'venues.id'
                ).each_with_object({}) { |v, h| h[v.id] = v.distance }
                Event.nearest(@venues_with_distance.keys)
              else
                Event.filter_by(params[:filter], id)
              end
    @events = @events.preload(:venue, :performer, pictures_attachments: :blob)
                     .paginate(page: params[:page], per_page: 3)
    @original_url = request.original_url
    @filter = params[:filter]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @event = Event.new
  end

  def show
    ActiveRecord::Associations::Preloader
      .new.preload(@event, [{ pictures_attachments: :blob },
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

  def edit
    authorize! :edit, @event
  end

  def update
    if @event.update(event_params)
      redirect_to action: 'index', notice: 'Updated successfully'
    else
      flash[:alert] = @event.errors.full_messages.join('; ')
      render :edit
    end
  end

  def destroy
    if @event.end_time > Time.now && @event.orders.any?
      render json: { error: "You can't delete future events that have tickets!" },
             status: :method_not_allowed
    else
      @event.destroy
      render json: { id: @event.id }
    end
  end

  private

  def find_event
    @event = Event.find(params[:id])
  end

  def event_params
    name = params.require(:event).fetch(:performer_name) { nil }
    performer = if name
                  Performer.new(name: name)
                else
                  Performer.find params.require(:event).fetch(:performer_id)
                end

    params.require(:event).permit(:title, :description, :total_number_of_tickets,
                                  :start_time, :end_time, :venue_id,
                                  :ticket_price_currency, :ticket_price,
                                  pictures: []).merge!(performer: performer)
  end
end
