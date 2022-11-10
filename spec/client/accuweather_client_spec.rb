# frozen_string_literal: true

require 'rails_helper'

describe AccuweatherClient do
  subject { described_class.new(Rails.application.credentials.accuweather_apikey) }

  describe '#historical_current_conditions', :vcr do
    let(:result) { subject.historical_current_conditions }

    it 'has an array of weather conditions data' do
      expect(result).to be_an_instance_of(Array)
      expect(result.first.keys).to include('EpochTime', 'Temperature')
    end
  end
end
