# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'with valid attributes' do
    it 'should be valid' do
      expect(create(:order)).to be_valid
    end
  end

  context 'with invalid attributes' do
    context 'with invalid user_id' do
      it 'should be invalid' do
        expect(build(:order, user_id: nil)).to_not be_valid
      end
    end

    context 'with invalid event_id' do
      it 'should be invalid' do
        expect(build(:order, event_id: 'eeeee')).to_not be_valid
      end
    end
  end
end
