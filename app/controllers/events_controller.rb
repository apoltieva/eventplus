class EventsController < ApplicationController
  def index
    @events = Event.all.order('start_time ASC')
  end

  def new; end

  def update; end

  def destroy; end
end
