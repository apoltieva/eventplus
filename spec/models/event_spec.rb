require 'rails_helper'

RSpec.describe Event, type: :model do
  context "with invalid attributes" do
    it "is not valid without a title" do
      expect(build(:event, title: nil)).to_not be_valid
    end
    it "is not valid without an venue ID" do
      expect(build(:event, venue_id: nil)).to_not be_valid
    end
  end
end

