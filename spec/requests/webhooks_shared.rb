# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'handles event processing' do
  include ActionMailer::TestHelper

  let!(:customer) { create(:user, role: :customer) }
  let!(:order) { create(:order, user: customer, status: :created) }
  let!(:event) { double('event') }

  context 'with valid event type' do
    before(:each) do
      allow(event).to receive(:type) { 'charge.succeeded' }
      allow(event).to receive_message_chain('data.object.id') { SecureRandom.uuid }
      allow(event).to receive_message_chain('data.object.customer') { customer.stripe_id }
    end
    context 'with successful payment' do
      before(:each) do
        allow(event).to receive_message_chain('data.object.paid') { 'true' }
      end
      it 'sends tickets' do
        assert_enqueued_email_with(TicketMailer, :mail_tickets, args: { order: order }) do
          EventHandler.call(event)
        end
      end
      it 'changes order status' do
        expect { EventHandler.call(event) }.to change { order.reload.status }.from('created')
                                                                               .to('success')
      end
    end
    context 'with failed payment' do
      before(:each) do
        allow(event).to receive_message_chain('data.object.paid') { false }
      end
      it 'sends an email notifying about the failure' do
        assert_enqueued_emails 1 do
          EventHandler.call(event)
        end
      end
      it 'changes order status' do
        expect { EventHandler.call(event) }.to change { order.reload.status }.from('created')
                                                                               .to('failure')
      end
    end
  end

  it 'rejects unknown event types' do
    allow(event).to receive(:type) { 'not_a_valid_event_type' }
    expect { EventHandler.call(event) }.to raise_error Exceptions::InvalidEventType
  end
end
