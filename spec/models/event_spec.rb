# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'with valid attributes' do
    it 'should be valid' do
      expect(create(:event)).to be_valid
    end
  end
  context 'with invalid attributes' do
    it 'is not valid without the title' do
      expect(build(:event, title: nil)).to_not be_valid
    end
    it 'is not valid without the venue ID' do
      expect(build(:event, venue_id: nil)).to_not be_valid
    end
    it 'is not valid without the performer', performer: true do
      expect(build(:event, performer_id: nil)).to_not be_valid
    end
    it 'is not valid without the starting time' do
      expect(build(:event, start_time: nil)).to_not be_valid
    end
    it 'is not valid without the ending time' do
      expect(build(:event, end_time: nil)).to_not be_valid
    end
    it 'is not valid without the total number of tickets' do
      expect(build(:event, total_number_of_tickets: nil)).to_not be_valid
    end
    it 'is not valid if the total number of tickets is not a number' do
      expect(build(:event, total_number_of_tickets: "not_a_number")).to_not be_valid
    end
    it 'is not valid if the total number of tickets is less than 0' do
      expect(build(:event, total_number_of_tickets: -5)).to_not be_valid
    end
    it 'is not valid if the ticket price is not a number' do
      expect(build(:event, ticket_price_cents: "not_a_number")).to_not be_valid
    end
    it 'is not valid if the ticket price is less than 0' do
      expect(build(:event, ticket_price_cents: -5)).to_not be_valid
    end
  end
  context 'if the performer does not exits' do
    it 'should create new performer' do
      expect(
        create(:event, performer: Performer.new(name: Faker::Name.name))
      ).to be_valid
    end
  end
end
