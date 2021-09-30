# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TicketMailer, type: :mailer do
  describe '#mail_tickets' do
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    let(:order) { create(:order, event: event, user: user) }
    let(:mailer) { described_class.with(order: order).mail_tickets }
    it 'should email the tickets for an event to the user' do
      expect(mailer.subject).to eq('Your Event+ tickets')
      expect(mailer.to).to eq([user.email])
      expect(mailer.from).to eq(['eventplus.mailer@gmail.com'])
      expect(mailer.body.encoded).to include(user.email)
      expect(mailer.body.encoded).to include(event.title)
    end
  end
end
