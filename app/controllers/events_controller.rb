# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :find_event, only: %i[destroy update edit show]
  authorize_resource
  before_action :find_events_num_of_tickets, only: %i[index show]

  def index
    @location = request.safe_location || 'Kiev, Ukraine'
    # if current_user
    #   user_id = current_user.id
    #   @order = Order.new
    # end
    # @events = case params[:filter]
    #           when 'keyword'
    #             Event.filter_by_keyword params[:keyword]
    #           when 'nearest'
    #             coords = Geocoder.search(location).first.coordinates
    #             @venues_with_distance = Venue.near(
    #               coords, 20_000, units: :km, select: 'venues.id'
    #             ).each_with_object({}) { |v, h| h[v.id] = v.distance }
    #             Event.nearest(@venues_with_distance.keys)
    #           else
    #             Event.filter_by(params[:filter], user_id)
    #           end
    # @events = @events.preload(:performer, :venue, pictures_attachments: :blob)
    #                  .paginate(page: params[:page], per_page: 3)
    #
    # keywords = Event.with_keywords.pluck(:keywords).flatten
    # @keywords_rating = keywords.uniq.sort_by { |e| -keywords.count(e) }
    # @original_url = request.original_url
    # @filter = params[:filter]
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
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
      flash[:notice] = 'Created successfully'
      redirect_to action: 'index'
    else
      flash[:alert] = @event.errors.full_messages.join('; ')
      render :new
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      flash[:alert] = 'Updated successfully'
      redirect_to action: 'index'
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

  def find_events_num_of_tickets
    @events_num_of_tickets = if current_user
                               current_user.orders.group(:event_id).sum(:quantity)
                             else
                               {}
                             end
  end

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
