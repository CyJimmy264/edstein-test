# frozen_string_literal: true

require 'swagger_helper'

describe 'Historical API' do
  context 'with 40 records of temperature from 49 to 10' do
    let(:data_count) { 40 }
    let(:maximum_per_past_day) { 33 }
    let(:minimum_per_past_day) { 10 }
    let(:average_per_past_day) { (10..33).sum / 24.0 }

    before do
      data_count.times do |i|
        create(:accuweather_datum,
               epoch_time: Time.now.advance(minutes: -40, hours: -i).to_i,
               temperature: i + 10)
      end
    end

    path '/weather/historical/' do
      get 'Retrieves historical conditions for past day' do
        tags 'Historical Weather'
        produces 'application/json'

        response '200', 'Historical conditions' do
          schema type: :array,
                 items: {
                   type: :object,
                   properties: {
                     epoch_time: { type: :integer },
                     temperature: { type: :number },
                   },
                 }

          let(:response_count) { 24 }

          run_test!

          it 'returns 24 conditions' do
            expect(JSON.parse(response.body).length).to eq response_count
          end
        end
      end
    end

    path '/weather/historical/max' do
      get 'Retrieves maximum temperature for past day' do
        tags 'Historical Maximum Temperature'
        produces 'application/json'

        response '200', 'Maximum temperature' do
          schema type: :object,
                 properties: {
                   epoch_time: { type: :integer },
                   temperature: { type: :number },
                 }

          run_test!

          it 'returns maximum per past day' do
            expect(JSON.parse(response.body)['temperature']).to eq maximum_per_past_day
          end
        end
      end
    end

    path '/weather/historical/min' do
      get 'Retrieves minimum temperature for past day' do
        tags 'Historical Minimum Temperature'
        produces 'application/json'

        response '200', 'Minimum temperature' do
          schema type: :object,
                 properties: {
                   epoch_time: { type: :integer },
                   temperature: { type: :number },
                 }

          run_test!

          it 'returns minimum per past day' do
            expect(JSON.parse(response.body)['temperature']).to eq minimum_per_past_day
          end
        end
      end
    end

    path '/weather/historical/avg' do
      get 'Retrieves average temperature for past day' do
        tags 'Historical Average Temperature'
        produces 'application/json'

        response '200', 'Average temperature' do
          schema type: :object,
                 properties: {
                   average: { type: :number },
                 }

          run_test!

          it 'returns averate per past day' do
            expect(JSON.parse(response.body)['average']).to eq average_per_past_day
          end
        end
      end
    end
  end
end
