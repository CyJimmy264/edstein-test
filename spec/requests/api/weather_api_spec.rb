# frozen_string_literal: true

require 'swagger_helper'

describe 'Weather API' do
  path '/weather/current' do
    get 'Retrieves the current conditions' do
      tags 'Current Weather'
      produces 'application/json'

      response '200', 'Current conditions' do
        schema type: :object,
               properties: {
                 epoch_time: { type: :integer },
                 temperature: { type: :number },
               }

        before { create(:accuweather_datum, epoch_time: Time.now.advance(minutes: -40).to_i) }

        run_test!
      end
    end
  end

  path '/weather/by_time/{time}' do
    get 'Retrieves conditions by certain time' do
      tags 'By Time Weather'
      produces 'application/json'
      parameter name: :time, in: :path, type: :string

      response '200', 'Conditions by time' do
        schema type: :object,
               properties: {
                 epoch_time: { type: :integer },
                 temperature: { type: :number },
               }

        let(:time) { Time.now.to_i }

        before { create(:accuweather_datum, epoch_time: Time.now.advance(minutes: -20).to_i) }

        run_test!
      end

      response '404', 'Not found' do
        schema type: :object,
               properties: {
                 error: { type: :string },
               }

        let(:time) { Time.now.to_i }

        before { create(:accuweather_datum, epoch_time: Time.now.advance(minutes: -40).to_i) }

        run_test! do |response|
          expect(JSON.parse(response.body)['error']).to eq 'Not Found'
        end
      end
    end
  end
end
