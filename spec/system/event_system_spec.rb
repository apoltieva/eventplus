# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'all events' do
  it 'can see all events' do
    expect(page).to have_text('Event+')
    Event.all.each do |e|
      expect(page).to have_text(e.title)
      expect(page).to have_text(e.description[0...100])
      expect(page).to have_text(e.performer.name)
      expect(page).to have_text(e.venue.name)
      expect(page).to have_text(e.total_number_of_tickets)
      e = e.decorate
      expect(page).to have_text(e.fee)
      expect(page).to have_text(e.start_end.gsub('  ', ' '))
    end
  end
end

RSpec.describe 'Event management', type: :system do
  include ActionMailer::TestHelper

  before do
    driven_by(:rack_test)
  end

  before(:each) do
    create(:event)
    create(:event)
    visit events_path
  end
  context 'unregistered user' do
    include_examples 'all events'
    scenario "can't buy tickets without registering" do
      expect(page).to have_button('Buy', disabled: true)
      expect(page).to have_button('Login')
      expect(page).to have_button('Register')
    end
  end
  context 'registered customer' do
    before(:each) do
      sign_in_as_a_valid_customer
      visit events_path
      assert_enqueued_emails 1 do
        page.first('#order_quantity').fill_in with: 4
        click_button 'Buy', match: :first
      end
    end
    include_examples 'all events'
    scenario 'can see how many tickets they have bought for each event' do
      expect(page).to have_text('4 tickets')
    end
    scenario 'can filter events using tabs “All events” and “Your events”' do
      click_link 'Your events'
      expect(page).to have_text('4 tickets')
      click_link 'All events'
      Event.all.each do |e|
        expect(page).to have_text(e.title)
      end
    end
    scenario 'can buy several ticket for one event' do
      expect(page).to have_text 'Your tickets will be sent to your email'
    end
  end
  context 'admin' do
    before(:each) do
      sign_in_as_a_valid_admin
      visit events_path
    end
    let!(:event) { Event.order(:start_time).first }
    include_examples 'all events'
    context 'can CRUD events using appropriate buttons' do
      scenario 'can delete events without tickets for future events' do
        expect { click_button 'Delete', match: :first }.to change { Event.count }.by(-1)
      end
      scenario 'can edit events' do
        click_button 'Edit', match: :first
        new_title = 'New title'
        expect(page).to(
          have_current_path(edit_event_path(event.id))
        )
        fill_in 'event_title', with: new_title
        click_button 'Update Event'
        expect(page).to have_text new_title
        expect(Event.find(event.id).title).to eq new_title
      end
      scenario 'can create new events' do
        click_button 'Create'
        expect(page).to have_current_path new_event_path
      end
    end
    scenario "can't delete events with tickets for future events" do
      create(:order, event_id: event.id)
      expect { click_button 'Delete', match: :first }.to change { Event.count }.by(0)
      expect(page).to have_text(/can't delete/i)
    end
  end
end
