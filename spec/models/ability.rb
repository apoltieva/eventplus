# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'User' do
    describe 'abilities' do
      describe 'Admin' do
        user = User.create!(email: 'admin@gmail.com', password: '23232323', role: 1)
        subject(:ability) { Ability.new(user) }
        let(:user) { create(:admin) }

        it { is_expected.to be_able_to(:manage, :all) }
        context 'can manage Venue' do
          it { is_expected.to be_able_to(:access, Venue) }
          it { is_expected.to be_able_to(:create, Venue) }
          it { is_expected.to be_able_to(:read, Venue) }
          it { is_expected.to be_able_to(:update, Venue) }
          it { is_expected.to be_able_to(:delete, Venue) }
        end
        context 'can manage Event' do
          it { is_expected.to be_able_to(:access, Event) }
          it { is_expected.to be_able_to(:create, Event) }
          it { is_expected.to be_able_to(:read, Event) }
          it { is_expected.to be_able_to(:update, Event) }
          it { is_expected.to be_able_to(:delete, Event) }
        end
      end

      describe 'Customer' do
        user = User.create!(email: 'customer@gmail.com', password: '23232323')
        subject(:ability) { Ability.new(user) }
        let(:user) { create(:customer) }

        it { is_expected.to be_able_to(:read, Event) }
        it { is_expected.to be_able_to(:create, Order) }

        it { is_expected.to_not be_able_to(:update, Event) }
        it { is_expected.to_not be_able_to(:delete, Event) }
        it { is_expected.to_not be_able_to(:access, Venue) }
        it { is_expected.to_not be_able_to(:create, Venue) }
        it { is_expected.to_not be_able_to(:read, Venue) }
        it { is_expected.to_not be_able_to(:update, Venue) }
        it { is_expected.to_not be_able_to(:delete, Venue) }
      end
    end
  end
end
