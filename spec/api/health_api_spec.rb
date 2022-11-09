# frozen_string_literal: true

require 'rails_helper'

describe HealthApi, type: :api do
  context 'GET /health' do
    it 'returns http status 200' do
      expect(call_api.status).to eq(200)
    end

    it 'returns JSON' do
      call_api
      expect(last_response.body).to eq({ status: 'OK' }.to_json)
    end
  end
end
