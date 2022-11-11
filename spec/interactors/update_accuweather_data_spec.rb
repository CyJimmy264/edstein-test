# frozen_string_literal: true

require 'rails_helper'

describe UpdateAccuweatherData do
  subject(:call) { described_class.call }

  let(:epoch_time1) { 1668082357 }
  let(:epoch_time2) { 1668083357 }
  let(:temperature1) { 1.5 }
  let(:temperature2) { 2.8 }

  let(:conditions) do # in reverse order, same as in the source
    [
      {
        'EpochTime' => epoch_time2,
        'Temperature' => { 'Metric' => { 'Value' => temperature2 } },
      },
      {
        'EpochTime' => epoch_time1,
        'Temperature' => { 'Metric' => { 'Value' => temperature1 } },
      },
    ]
  end

  let(:accuweather_client) do
    instance_double(AccuweatherClient, historical_current_conditions: conditions)
  end

  before { allow(AccuweatherClient).to receive(:new).and_return(accuweather_client) }

  context 'when conditions are not present in DB' do
    it 'adds conditions in reverse order' do
      expect { call }.to change(AccuweatherDatum, :count).by(2)
      expect(AccuweatherDatum.first)
        .to have_attributes(epoch_time: epoch_time1, temperature: temperature1)
      expect(AccuweatherDatum.last)
        .to have_attributes(epoch_time: epoch_time2, temperature: temperature2)
    end
  end

  context 'when one of two conditions are in DB' do
    before { create(:accuweather_datum, epoch_time: epoch_time1, temperature: 7.7) }

    it 'updates the old and adds the new condition' do
      expect { call }.to change(AccuweatherDatum, :count).by(1)
      expect(AccuweatherDatum.first)
        .to have_attributes(epoch_time: epoch_time1, temperature: temperature1)
      expect(AccuweatherDatum.last)
        .to have_attributes(epoch_time: epoch_time2, temperature: temperature2)
    end
  end
end
