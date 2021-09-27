# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'all venues' do
  it 'can see all events' do
    expect(page).to have_button 'Venues'
    venues.each do |v|
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

  let!(:venues) { create_list(:venue, 2) }
  before(:each) do
    sign_in_as_a_valid_admin
    visit venues_path
  end
  context 'admin' do
    let(:first_venue) { venues[0] }
    include_examples 'all venues'
    context 'can CRUD venues using appropriate buttons' do
      scenario 'can delete venues without tickets for future events' do
        expect { click_button 'Delete', match: :first }.to change { Venue.count }.by(-1)
      end
      scenario 'can edit venues' do
        click_button 'Edit', match: :first
        new_name = 'New name'
        expect(page).to(
          have_current_path(edit_venue_path(first_venue.id))
        )
        fill_in 'venue_name', with: new_name
        click_button 'Update Venue'
        expect(page).to have_text new_name
        expect(first_venue.reload.name).to eq new_name
      end
      scenario 'can create new venues' do
        click_button 'Create'
        expect(page).to have_current_path new_venue_path
      end
    end
    scenario "can't delete venues with tickets for future events" do
      create(:order, event: create(:event, venue: first_venue))
      expect { click_button 'Delete', match: :first }.to change { Venue.count }.by(0)
      expect(page).to have_text(/can't delete/i)
    end
  end
end
