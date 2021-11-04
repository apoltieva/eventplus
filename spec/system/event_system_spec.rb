# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'all events' do |admin|
  it 'can see all events' do
    expect(page).to have_text('Event+')
    events.each do |e|
      check_event_info(e)
    end
  end
  it 'can see the show page of an event' do
    visit_first_event(admin, events[0])
  end
end

RSpec.describe 'Event management', type: :system do
  include ActionMailer::TestHelper

  before do
    driven_by(:selenium_headless)
  end

  let!(:events) do
    create_list(:event, 2) do |e, i|
      e.start_time = Time.now + (i * 2).days
    end
  end

  context 'unregistered user' do
    before(:each) do
      visit events_path
    end
    include_examples 'all events', false
    scenario "can't buy tickets without registering" do
      expect(page).to have_button('Buy', disabled: true)
      expect(page).to have_button('Login')
      expect(page).to have_button('Register')
    end
  end
  context 'registered customer' do
    before(:each) do
      sign_in_as_a_valid_customer
      create(:order, user_id: @user.id, event: events[0], status: :success, quantity: 4)
      visit events_path
    end
    include_examples 'all events', false
    scenario 'can see how many tickets they have bought for each event' do
      expect(page.find_by_id(events[0].id.to_s)).to have_text('4 tickets')
    end

    scenario 'can filter events using tabs “All events”, “Past events”, ' \
      '“Near you”, “Your events”, and “Your past events”' do
      click_link 'Your events'
      expect(page).to have_text('4 tickets')
      expect(page).to have_text(events[0].title)
      click_link 'All events'
      events.each do |e|
        expect(page).to have_text(e.title)
      end
      click_link 'Near you'
      expect(page).to have_text('km from you', minimum: 1)
      create(:order, user_id: @user.id,
                     event: create(:event, title: 'Event in the past',
                                           start_time: 3.days.ago,
                                           end_time: 2.days.ago),
                     quantity: 3,
                     status: :success)
      click_link 'Your past events'
      expect(page).to have_text('Event in the past')
      expect(page).to have_text('3 tickets')
      click_link 'Past events'
      expect(page).to have_text('Event in the past')
    end
  end
  context 'admin' do
    before(:each) do
      sign_in_as_a_valid_admin
      visit events_path
    end
    include_examples 'all events', true
    context 'can CRUD events using appropriate buttons' do
      scenario 'can delete events without tickets for future events' do
        expect { click_button 'Delete', match: :first }.to change { Event.count }.by(-1)
      end
      let(:new_title) { 'New title' }
      scenario 'can edit events' do
        page.find_by_id(events[0].id.to_s).find_button('Edit').click
        expect(page).to(
          have_current_path(edit_event_path(events[0].id))
        )
        fill_in 'event_title', with: new_title
        expect { click_button 'Update Event' }.to have_broadcasted_to('events')
        expect(page).to have_text new_title
        expect(events[0].reload.title).to eq new_title
      end
      scenario 'can create new events and a new performer', js: true do
        click_button 'Create'
        expect(page).to have_current_path new_event_path
        expect do
          fill_in 'event_title', with: 'Event title'
          click_link 'Create performer'
          page.find_by_id('new_performer').fill_in with: 'New performer'
          fill_in 'event_total_number_of_tickets', with: 2333
          fill_in 'event_ticket_price', with: 23.35
          find('#event_start_time_3i').find(:option, (Time.now + 1.day).day).select_option
          find('#event_end_time_1i').find(:option, (Time.now + 1.year).year).select_option
          expect { click_button 'Create Event' }.to change { Performer.count }.by 1
        end.to change { Event.count }.by 1
      end
    end
    scenario "can't delete events with tickets for future events", js: true do
      create(:order, event_id: events[0].id, status: :success)
      expect { page.find_by_id(events[0].id.to_s).find_button('Delete').click }
        .to change { Event.count }.by(0)
    end
  end
end
