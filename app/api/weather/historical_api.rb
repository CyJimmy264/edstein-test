# frozen_string_literal: true

# :nodoc:
class Weather::HistoricalApi < Grape::API
  prefix 'weather/historical'

  helpers do
    def data_past_day
      AccuweatherDatum.where(epoch_time: Time.now.prev_day.to_i..Time.now.to_i)
    end
  end

  get '/' do
    data_past_day
      .order(epoch_time: :desc)
      .select(:epoch_time, :temperature)
      .as_json(except: :id)
  end

  get '/max' do
    data_past_day
      .order(temperature: :desc)
      .select(:epoch_time, :temperature)
      .first
      .as_json(except: :id)
  end

  get '/min' do
    data_past_day
      .order(temperature: :asc)
      .select(:epoch_time, :temperature)
      .first
      .as_json(except: :id)
  end

  get '/avg' do
    {
      average: data_past_day.average(:temperature).round(1),
    }
  end
end
