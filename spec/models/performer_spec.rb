# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Performer, type: :model do
  context 'with valid attributes' do
    it 'should be valid' do
      expect(create(:performer)).to be_valid
    end
  end

  context 'with invalid attributes' do
    context 'with invalid name' do
      it 'should be invalid' do
        expect(build(:performer, name: nil)).to_not be_valid
      end
    end
  end
end
