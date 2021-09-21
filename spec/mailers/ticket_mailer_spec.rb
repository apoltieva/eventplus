# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TicketMailer, type: :mailer do
  describe '#mail_tickets' do
    specify 'should email the tickets for an event to the user' do
      user = create(:user)
      event = create(:event)
      order = create(:order, event_id: event.id, user_id: user.id)
      mailer = described_class.with(order: order).mail_tickets
      expect(mailer.subject).to eq('Your Event+ tickets')
      expect(mailer.to).to eq([user.email])
      expect(mailer.from).to eq(['eventplus.mailer@gmail.com'])
      expect(mailer.body.encoded).to include(user.email)
      expect(mailer.body.encoded).to include(event.title)
    end
  end
end
