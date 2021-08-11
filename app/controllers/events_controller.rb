# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = Event.all.order(:start_time)
  end

  def new; end

  def update; end

  def destroy; end
end
