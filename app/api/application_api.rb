# frozen_string_literal: true

class ApplicationApi < Grape::API
  format :json
  mount HealthApi
  mount WeatherApi
  mount Weather::HistoricalApi
end
