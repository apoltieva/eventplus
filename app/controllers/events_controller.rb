class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def new; end

  def update; end

  def destroy; end
end
