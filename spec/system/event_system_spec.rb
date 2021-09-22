# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'all events' do |admin|
  it 'can see all events' do
    expect(page).to have_text('Event+')
    Event.all.future.each do |e|
      check_event_info(e)
    end
  end
  it 'can see the show page of an event' do
    visit_first_event(admin)
  end
end

RSpec.describe 'Event management', type: :system do
  include Warden::Test::Helpers
  before do
    driven_by(:selenium_headless)
  end

  before(:each) do
    create(:event)
    create(:event)
    visit events_path
  end
  context 'unregistered user' do
    include_examples 'all events', false
  end
  context 'registered user' do
    include_examples 'all events', false
  end
  context 'admin' do
    before(:each) do
      @user ||= create(:user, role: 1)
      login_as @user
    end
    include_examples 'all events', true
  end
end
