# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Venues', type: :request do
  it 'should generate correct routes' do
    assert_routing({ path: 'venues', method: :post },
                   { controller: 'venues', action: 'create' })
    assert_routing({ path: 'venues', method: :get },
                   { controller: 'venues', action: 'index' })
    assert_routing({ path: 'venues/new', method: :get },
                   { controller: 'venues', action: 'new' })
    assert_routing({ path: 'venues/1', method: :patch },
                   { controller: 'venues', action: 'update', id: '1' })
    assert_routing({ path: 'venues/1', method: :put },
                   { controller: 'venues', action: 'update', id: '1' })
    assert_routing({ path: 'venues/1', method: :delete },
                   { controller: 'venues', action: 'destroy', id: '1' })
    assert_routing({ path: 'venues/1/edit', method: :get },
                   { controller: 'venues', action: 'edit', id: '1' })
  end

  before(:each) { sign_in_as_a_valid_admin }
  let!(:venue_shared) { create(:venue) }

  describe 'GET /venues' do
    let!(:venue1) { create(:venue) }
    before(:each) { get venues_path }
    it 'should render the correct template' do
      expect(response).to have_http_status :ok
      expect(response).to render_template :index
    end
    it 'should display all venues' do
      expect(response.body).to include(venue1.name)
      expect(response.body).to include(venue_shared.name)
    end
  end

  describe 'POST /venues' do
    context 'with valid parameters' do
      it 'should save the venue' do
        expect { post venues_path, params: { venue: JSON.parse(build(:venue).to_json) } }
          .to change { Venue.count }.by(1)
      end
    end
    context 'with invalid parameters' do
      context 'name errors' do
        after(:each) { expect(flash[:alert].downcase).to include('name') }
        context 'without name' do
          it 'should explain error' do
            expect do
              post venues_path, params: { venue: JSON.parse(build(:venue, name: nil)
                                                .to_json) }
            end.to change { Venue.count }.by(0)
          end
        end
      end
      context 'latitude errors' do
        after(:each) { expect(flash[:alert].downcase).to include('latitude') }
        context 'without latitude' do
          it 'should explain error' do
            expect do
              post venues_path, params: { venue: JSON.parse(build(:venue, latitude: nil)
                                                              .to_json) }
            end.to change { Venue.count }.by(0)
          end
        end
        context 'with invalid latitude' do
          it 'should explain error' do
            expect do
              post venues_path, params: { venue: JSON.parse(build(:venue, latitude: -400)
                                                              .to_json) }
            end.to change { Venue.count }.by(0)
          end
        end
      end

      context 'longitude errors' do
        after(:each) { expect(flash[:alert].downcase).to include('longitude') }
        context 'without longitude' do
          it 'should explain error' do
            expect do
              post venues_path, params: { venue: JSON.parse(build(:venue, longitude: nil)
                                                              .to_json) }
            end.to change { Venue.count }.by(0)
          end
        end
        context 'with invalid longitude' do
          it 'should explain error' do
            expect do
              post venues_path, params: { venue: JSON.parse(build(:venue, longitude: -400)
                                                              .to_json) }
            end.to change { Venue.count }.by(0)
          end
        end
      end
    end
  end

  describe 'GET /venues/new' do
    it 'should render the correct template' do
      get new_venue_path
      expect(response).to have_http_status :ok
      expect(response).to render_template :new
    end
  end

  describe 'PUT /venues/:id' do
    context 'with valid parameters' do
      it 'should update the venue' do
        name = 'New name'
        put venue_path(venue_shared.id), params: { venue: JSON.parse(build(:venue,
                                                                           name: name).to_json) }
        expect(venue_shared.reload.name).to eq(name)
      end
    end
    context 'with invalid parameters' do
      context 'with invalid id' do
        it 'should explain error' do
          put venue_path(venue_shared.id + 10_000), params: { venue: JSON.parse(build(:venue).to_json) }
          expect(flash[:alert].downcase).to include('id')
        end
      end
      context 'name errors' do
        after(:each) do
          expect(flash[:alert].downcase).to include('name')
          expect(venue_shared.name).to eq venue_shared.reload.name
        end
        context 'without name' do
          it 'should explain error' do
            put venue_path(venue_shared.id),
                params: { venue: JSON.parse(build(:venue, name: nil)
                                              .to_json) }
          end
        end
      end
      context 'latitude errors' do
        after(:each) do
          expect(flash[:alert].downcase).to include('latitude')
          expect(venue_shared.latitude).to eq venue_shared.reload.latitude
        end
        context 'without latitude' do
          it 'should explain error' do
            put venue_path(venue_shared.id),
                params: { venue: JSON.parse(build(:venue, latitude: nil).to_json) }
          end
        end
        context 'with invalid latitude' do
          it 'should explain error' do
            put venue_path(venue_shared.id),
                params: { venue: JSON.parse(build(:venue, latitude: -400).to_json) }
          end
        end
      end
      context 'longitude errors' do
        after(:each) do
          expect(flash[:alert].downcase).to include('longitude')
          expect(Venue.find(venue_shared.id).longitude).to eq venue_shared.longitude
        end
        context 'without latitude' do
          it 'should explain error' do
            put venue_path(venue_shared.id),
                params: { venue: JSON.parse(build(:venue, longitude: nil).to_json) }
          end
        end
        context 'with invalid latitude' do
          it 'should explain error' do
            put venue_path(venue_shared.id),
                params: { venue: JSON.parse(build(:venue, longitude: -400).to_json) }
          end
        end
      end
    end
  end

  describe 'GET /venues/:id/edit' do
    context 'with valid id' do
      it 'should render the correct template' do
        get edit_venue_path(venue_shared.id)
        expect(response).to have_http_status :ok
        expect(response).to render_template :edit
      end
      it 'should display the venue' do
        get edit_venue_path(venue_shared.id)
        expect(response.body).to include(venue_shared.name)
      end
    end
    context 'with invalid id' do
      it 'should explain error' do
        get edit_event_path(venue_shared.id + 10_000)
        expect(flash[:alert].downcase).to include('id')
      end
    end
  end

  describe 'DELETE /venues/:id' do
    context 'with valid id' do
      let!(:future_event) { create(:event, venue_id: venue_shared.id) }
      context 'without orders for future events' do
        it 'should delete venue' do
          expect { delete venue_path(venue_shared.id) }.to change { Event.count }.by(-1)
          expect(response.body).to include(venue_shared.id.to_s)
        end
      end
      context 'with orders for future events' do
        before(:each) { create(:order, event_id: future_event.id) }
        it 'should explain error' do
          expect { delete venue_path(venue_shared.id) }.to change { Event.count }.by(0)
          expect(response.body)
            .to include("You can't delete venues with future events that have tickets!")
        end
      end
    end
    context 'with invalid id' do
      it 'should explain error' do
        expect { delete venue_path(venue_shared.id + 10_000) }.to change { Event.count }.by 0
        expect(flash[:alert].downcase).to include('id')
      end
    end
  end
end
