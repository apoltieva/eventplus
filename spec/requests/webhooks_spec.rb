# frozen_string_literal: true

require 'rails_helper'
require_relative './webhooks_shared'

RSpec.describe 'Webhooks', type: :request do
  it 'should generate correct route' do
    assert_routing({ path: 'webhooks', method: :post },
                   { controller: 'webhooks', action: 'create' })
  end
  include_examples 'handles event processing'
end
