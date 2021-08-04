require 'rails_helper'

RSpec.describe "Events", type: :request do
  it 'shouldgenerate correct routes' do
    assert_routing({ path: 'events', method: :post }, { controller: 'events', action: 'create' })
    assert_routing({ path: 'events', method: :get }, { controller: 'events', action: 'index' })
    assert_routing({ path: 'events/new', method: :get }, { controller: 'events', action: 'new' })
    assert_routing({ path: 'events/1', method: :patch }, { controller: 'events', action: 'update', id: "1" })
    assert_routing({ path: 'events/1', method: :put }, { controller: 'events', action: 'update', id: "1" })
    assert_routing({ path: 'events/1', method: :delete }, { controller: 'events', action: 'destroy', id: '1' })
  end
end