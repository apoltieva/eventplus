# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  include ActionMailer::TestHelper

  describe '#create_session' do
    context 'creates checkout session' do
      context 'with free event' do
        let(:order_for_free_event) { create(:order, event: create(:event, ticket_price: 0.0)) }
        it 'allows session to redirect to success page and send tickets' do
          assert_enqueued_email_with(
            TicketMailer, :mail_tickets, args: { order: order_for_free_event }
          ) do
            expect(Checkout.create_session(order_for_free_event).url)
              .to eq Rails.application.routes.url_helpers.success_checkout_url(
                host: Rails.application.config.action_controller.default_url_options[:host]
              )
          end
        end
      end
      let(:third_party_checkout) { 'https://checkout.stripe.com/pay' }
      let(:billable_order) { create(:order, event: create(:event, ticket_price_cents: 10)) }
      context 'with billable event' do
        it 'allows session to redirect to third-party checkout' do
          expect(Checkout.create_session(billable_order).url
                         .starts_with?(third_party_checkout)).to be true
        end
      end
    end
  end
end
