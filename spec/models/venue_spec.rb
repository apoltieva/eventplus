# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Venue, type: :model do
  context "with valid attributes" do
    it "should be valid" do
      expect(create(:venue)).to be_valid
    end
  end
  context 'with invalid attributes' do
    it 'is not valid without a name' do
      expect(build(:venue, name: nil)).to_not be_valid
    end
    it 'is not valid without latitude' do
      expect(build(:venue, latitude: nil)).to_not be_valid
    end
    it 'is not valid without longitude' do
      expect(build(:venue, longitude: nil)).to_not be_valid
    end
  end
end
