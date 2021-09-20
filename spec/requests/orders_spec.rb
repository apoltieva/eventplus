# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  it 'should generate correct routes' do
    assert_routing({ path: 'orders', method: :post },
                   { controller: 'orders', action: 'create' })
    assert_routing({ path: 'orders/1', method: :get },
                   { controller: 'orders', action: 'show', id: '1' })
  end

  let!(:order_shared) { { event_id: create(:event).id, quantity: rand(1..10) } }
  before(:each) { sign_in_as_a_valid_customer }

  describe 'POST /orders' do
    context 'with valid parameters' do
      it 'should save the order and send email' do
        assert_enqueued_emails 1 do
          expect { post orders_path, params: { order: order_shared } }
            .to change { Order.count }.by 1
        end
      end
    end
    context 'with invalid parameters' do
      context 'event_id errors' do
        context 'with invalid event_id' do
          it 'should not save the order' do
            order_shared['event_id'] = 'dfdff'
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
      context 'quantity errors' do
        context 'with invalid quantity' do
          it 'should not save the order' do
            order_shared['quantity'] = 'dfdff'
            expect { post orders_path, params: { order: order_shared } }
              .to change { Order.count }.by 0
          end
        end
        context 'with no quantity' do
          it 'should not save the order' do
            expect { post orders_path, params: { order: { event_id: create(:event).id } } }
              .to change { Order.count }.by 0
          end
        end
      end
    end
  end

  describe 'GET /orders/:uuid' do
    context 'with valid uuid' do
      it 'should return json with the order' do
        order = create(:order)
        get order_path(order.uuid)
        expect(response.body).to include(order.id.to_s)
        expect(response.body).to include(order.user_id.to_s)
      end
    end
    context 'with invalid uuid' do
      it 'should return json with the error' do
        get order_path('not_uuid')
        expect(response).to have_http_status :not_found
        expect(response.body).to include('error')
        expect(response.body).to include('uuid')
      end
    end
  end
end
