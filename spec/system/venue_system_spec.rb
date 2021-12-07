# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'all venues' do
  it 'can see all venues' do
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
    driven_by(:selenium_headless)
  end

  let!(:venues) { create_list(:venue, 2) }
  before(:each) do
    sign_in_as_a_valid_admin
    visit venues_path(locale: I18n.default_locale)
  end
  let(:first_venue) { venues[0] }
  include_examples 'all venues'
  context 'can CRUD venues using appropriate buttons' do
    scenario 'can delete venues without tickets for future events' do
      expect { click_button 'Delete', match: :first }.to change { Venue.count }.by(-1)
    end
    let(:new_name) { 'New name' }
    scenario 'can edit venues' do
      click_button 'Edit', match: :first
      expect(page).to(
        have_current_path(edit_venue_path(first_venue.id, locale: I18n.default_locale))
      )
      fill_in 'venue_name', with: new_name
      click_button 'Update Venue'
      sleep 10
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
    dismiss_confirm(/can't delete/i) do
      expect { click_button 'Delete', match: :first }.to change { Venue.count }.by(0)
    end
  end
end
