# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  it 'should generate correct routes' do
    assert_routing({ path: 'orders', method: :post },
                   { controller: 'orders', action: 'create' })
    assert_routing({ path: 'orders/1', method: :get },
                   { controller: 'orders', action: 'show', id: '1' })
  end

  before(:each) { sign_in_as_a_valid_customer }

  describe 'POST /orders' do
    let(:valid_event) { create(:event) }
    let(:order_shared) { { event_id: valid_event.id, quantity: 3 } }
    context 'with valid parameters' do
      it 'should save the order and send email' do
        assert_enqueued_emails 1 do
          expect { post orders_path, params: { order: order_shared } }
            .to change { Order.count }.by 1
        end
      end
    end
    context 'with invalid parameters' do
      context 'quantity errors' do
        after(:each) { expect(flash[:alert].downcase).to include('quantity') }
        context 'with invalid quantity' do
          it 'should not save the order' do

            order_shared[:quantity] = 'dfdff'
            expect { post orders_path, params: { order: order_shared } }
              .to change { Order.count }.by 0
          end
        end
        context 'with no quantity' do
          it 'should not save the order' do
            expect { post orders_path, params: { order: { event_id: valid_event.id } } }
              .to change { Order.count }.by 0
          end
        end
      end
      context 'event_id errors' do
        after(:each) { expect(flash[:alert].downcase).to include('event') }
        context 'with invalid event_id' do
          it 'should not save the order' do
            order_shared[:event_id] = 'dfdff'
            expect { post orders_path, params: { order: order_shared } }
              .to change { Order.count }.by 0
          end
        end
        context 'with no event_id' do
          it 'should not save the order' do
            expect { post orders_path, params: { order: { quantity: 3 } } }
              .to change { Order.count }.by 0
          end
        end
      end
    end
  end

  describe 'GET /orders/:uuid' do
    let(:valid_order) { create(:order) }
    context 'with valid uuid' do
      it 'should return json with the order' do
        get order_path(valid_order.uuid)
        expect(response.body).to include(valid_order.id.to_s)
        expect(response.body).to include(valid_order.user_id.to_s)
      end
    end
    context 'with invalid uuid' do
      it 'should return json with the error' do
        get order_path('not_uuid')
        expect(response).to have_http_status :not_found
        expect(response.body).to include('uuid')
      end
    end
  end
end
