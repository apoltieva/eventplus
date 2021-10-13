# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events', type: :request do
  it 'should generate correct routes' do
    assert_routing({ path: 'events', method: :post }, { controller: 'events', action: 'create' })
    assert_routing({ path: 'events', method: :get }, { controller: 'events', action: 'index' })
    assert_routing({ path: 'events/1', method: :get },
                   { controller: 'events', action: 'show', id: '1' })
    assert_routing({ path: 'events/new', method: :get }, { controller: 'events', action: 'new' })
    assert_routing({ path: 'events/1', method: :patch },
                   { controller: 'events', action: 'update', id: '1' })
    assert_routing({ path: 'events/1', method: :put },
                   { controller: 'events', action: 'update', id: '1' })
    assert_routing({ path: 'events/1', method: :delete },
                   { controller: 'events', action: 'destroy', id: '1' })
    assert_routing({ path: 'events/1/edit', method: :get },
                   { controller: 'events', action: 'edit', id: '1' })
  end

  let(:performer) { create :performer }
  let(:venue) { create :venue }
  let!(:event_shared) do
    create(:event,
           start_time: Time.now + 2.days,
           end_time: Time.now + 4.days)
  end

  context 'without authentication' do
    describe 'GET /events' do
      let!(:event1) { create(:event) }
      it 'should render the correct template' do
        get events_path
        expect(response).to have_http_status :ok
        expect(response).to render_template :index
      end
      it 'should display all events' do
        get events_path
        expect(response.body).to include(event1.title)
        expect(response.body).to include(event_shared.title)
      end
    end

    describe 'GET /events/:id' do
      context 'with valid id' do
        it 'should render the correct template' do
          get event_path(event_shared.id)
          expect(response).to have_http_status :ok
          expect(response).to render_template :show
        end
        it 'should display the event' do
          get event_path(event_shared.id)
          expect(response.body).to include(event_shared.title)
        end
      end
      context 'with invalid id' do
        it 'should explain error' do
          get event_path(event_shared.id + 10_000)
          expect(flash[:alert].downcase).to include('id')
        end
      end
    end
  end
  ###############################################################################
  context 'with authentication' do
    before(:each) { sign_in_as_a_valid_admin }
    describe 'POST /index' do
      context 'with valid parameters' do
        it 'should save the event' do
          expect do
            post events_path, params:
              { event: JSON.parse(build(:event,
                                        performer_id: performer.id,
                                        venue_id: venue.id).to_json) }
          end.to change { Event.count }.by(1)
        end
      end

      context 'with invalid parameters' do
        context 'with invalid event parameters' do
          it 'should explain invalid event parameters' do
            post events_path, params:
              { event: JSON.parse(build(:event,
                                        title: nil,
                                        performer_id: performer.id,
                                        venue_id: venue.id).to_json) }
            expect(response).to render_template :new
            expect(flash[:alert].downcase).to include('title')
          end
        end
        context 'with invalid venue_id' do
          it 'should explain invalid venue_id' do
            post events_path, params:
              { event: JSON.parse(build(:event,
                                        performer_id: performer.id,
                                        venue_id: nil).to_json) }
            expect(response).to render_template :new
            expect(flash[:alert].downcase).to include('venue')
          end
        end
        context 'with invalid performer_id' do
          it 'should explain invalid performer' do
            post events_path, params:
              { event: JSON.parse(build(:event,
                                        performer_id: nil,
                                        venue_id: venue.id).to_json) }
            expect(flash[:alert].downcase).to include('performer')
            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context 'with invalid performer_name' do
          it 'should explain invalid performer' do
            event = JSON.parse(build(:event, venue_id: venue.id).to_json)
            event['performer_name'] = ''
            post events_path, params:
              { event: event }
            expect(flash[:alert].downcase).to include('performer')
            expect(response).to render_template :new
          end
        end
      end
    end

    describe 'GET /events/new' do
      it 'should render the correct template' do
        get new_event_path
        expect(response).to have_http_status :ok
        expect(response).to render_template :new
      end
    end

    describe 'PUT /events/:id' do
      context 'with valid parameters' do
        it 'should update the event' do
          title = Faker::Movie.title
          put event_path(event_shared.id), params:
            { event: JSON.parse(build(:event, title: title,
                                              performer_id: performer.id,
                                              venue_id: venue.id).to_json) }

          expect(event_shared.reload.title).to eq(title)
        end
      end

      context 'with invalid parameters' do
        context 'with invalid id' do
          it 'should explain invalid id' do
            put event_path(event_shared.id + 10_000), params:
              { event: JSON.parse(build(:event,
                                        performer_id: performer.id,
                                        venue_id: venue.id).to_json) }
            expect(flash[:alert].downcase).to include('id')
          end
        end
        context 'with invalid event parameters' do
          it 'should explain invalid event parameters' do
            put event_path(event_shared.id), params:
              { event: JSON.parse(build(:event, title: nil,
                                                performer_id: performer.id,
                                                venue_id: venue.id).to_json) }
            expect(response).to render_template :edit
            expect(flash[:alert].downcase).to include('title')
          end
        end
        context 'with invalid venue_id' do
          it 'should explain invalid venue_id' do
            put event_path(event_shared.id), params:
              { event: JSON.parse(build(:event,
                                        performer_id: performer.id,
                                        venue_id: nil).to_json) }
            expect(response).to render_template :edit
            expect(flash[:alert].downcase).to include('venue')
          end
        end
        context 'with invalid performer_id' do
          it 'should explain invalid performer' do
            put event_path(event_shared.id), params:
              { event: JSON.parse(build(:event,
                                        performer_id: nil,
                                        venue_id: venue.id).to_json) }
            expect(flash[:alert].downcase).to include('performer')
            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context 'with invalid performer_name' do
          let(:new_event) { JSON.parse(build(:event, venue_id: venue.id).to_json) }
          it 'should explain invalid performer' do
            new_event['performer_name'] = ''
            put event_path(event_shared.id), params:
              { event: new_event }
            expect(flash[:alert].downcase).to include('performer')
          end
        end
      end
    end

    describe 'GET /events/:id/edit' do
      context 'with valid id' do
        it 'should render the correct template' do
          get edit_event_path(event_shared.id)
          expect(response).to have_http_status :ok
          expect(response).to render_template :edit
        end
        it 'should display the event' do
          get edit_event_path(event_shared.id)
          expect(response.body).to include(event_shared.title)
        end
      end
      context 'with invalid id' do
        it 'should explain error' do
          get edit_event_path(event_shared.id + 10_000)
          expect(flash[:alert].downcase).to include('id')
        end
      end
    end

    describe 'DELETE /events/:id' do
      context 'with valid id' do
        context 'with order for future event' do
          it 'should not delete event' do
            create(:order, event_id: event_shared.id)
            expect { delete event_path(event_shared.id) }.to change { Event.count }.by(0)
            expect(response.body).to include('future')
            expect(response.body).to include("can't delete")
          end
        end
        context 'without orders for future event' do
          it 'should delete the event' do
            expect { delete event_path(event_shared.id) }.to change { Event.count }.by(-1)
            expect(response.body).to include(event_shared.id.to_s)
          end
        end
      end
      context 'with invalid id' do
        it 'should explain error' do
          delete event_path(event_shared.id + 10_000)
          expect(flash[:alert].downcase).to include('id')
        end
      end
    end
  end
end
