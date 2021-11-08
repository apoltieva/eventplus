# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsChannel, type: :channel do
  it 'subscribes to the channel' do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('events')
  end

  it 'makes broadcasts' do
    assert_broadcasts 'events', 0
    ActionCable.server.broadcast 'events', { text: 'hello' }
    assert_broadcasts 'events', 1
  end
end
