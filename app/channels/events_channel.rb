# frozen_string_literal: true

class EventsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'events'
  end
end
