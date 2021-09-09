# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :find_event, only: %i[destroy update edit show]

  def current_user
    @current_user ||= super.tap do |user|
      ::ActiveRecord::Associations::Preloader.new.preload(user, :events)
    end
  end

  def index
    @filter = params[:filter]
    @events_num_of_tickets = if current_user
                               current_user.orders.group(:event_id).sum(:quantity)
                             else
                               {}
                             end
    @events = Event.filter_by(params[:filter], event_filter_parameters)
                   .preload(:performer, :venue, pictures_attachments: :blob)
                   .paginate(page: params[:page], per_page: 3)
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
  rescue PG::NotNullViolation
    flash[:alert] = "Performer's name can't be blank!"
    render :edit
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
    name = params.require(:event).fetch(:performer_name) { nil }
    performer = if name
                  name = nil if name == ''
                  Performer.new(name: name)
                else
                  Performer.find params.require(:event).fetch(:performer_id)
                end
    params.require(:event).permit(:title, :description, :total_number_of_tickets,
                                  :start_time, :end_time, :venue_id,
                                  :ticket_price_currency, :ticket_price,
                                  pictures: []).merge!(performer: performer)
  end

  def event_filter_parameters
    user_id = current_user.id if current_user
    location = request.safe_location || 'Kiev, Ukraine'

    { location: location, user_id: user_id }
  end
end
