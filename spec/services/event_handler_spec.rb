# frozen_string_literal: true

require 'rails_helper'
require_relative '../requests/webhooks_shared'

RSpec.describe EventHandler, type: :model do
  describe '#call' do
    include_examples 'handles event processing'
  end
end
