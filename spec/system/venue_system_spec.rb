# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'all venues' do
  it 'can see all events' do
    expect(page).to have_button 'Venues'
    Venue.all.each do |v|
      expect(page).to have_text(v.name)
      if v.address
        expect(page).to have_text(v.address)
      else
        expect(page).to have_text(v.latitude)
        expect(page).to have_text(v.longitude)
      end
    end
  end
end

RSpec.describe 'Venue management', type: :system do
  before do
    driven_by(:rack_test)
  end

  before(:each) do
    create(:venue)
    create(:venue)
    sign_in_as_a_valid_admin
    visit venues_path
  end
  context 'admin' do
    let!(:venue) { Venue.all.first }
    include_examples 'all venues'
    context 'can CRUD venues using appropriate buttons' do
      scenario 'can delete venues without tickets for future events' do
        expect { click_button 'Delete', match: :first }.to change { Venue.count }.by(-1)
      end
      scenario 'can edit venues' do
        click_button 'Edit', match: :first
        new_name = 'New name'
        expect(page).to(
          have_current_path(edit_venue_path(venue.id))
        )
        fill_in 'venue_name', with: new_name
        click_button 'Update Venue'
        expect(page).to have_text new_name
        expect(Venue.find(venue.id).name).to eq new_name
      end
      scenario 'can create new events' do
        click_button 'Create'
        expect(page).to have_current_path new_venue_path
      end
    end
    scenario "can't delete events with tickets for future events" do
      create(:order, event_id: create(:event, venue_id: venue.id).id)
      expect { click_button 'Delete', match: :first }.to change { Venue.count }.by(0)
      expect(page).to have_text(/can't delete/i)
    end
  end
end
