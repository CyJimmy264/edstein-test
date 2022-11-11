# frozen_string_literal: true

# :nodoc:
class WeatherApi < Grape::API
  prefix 'weather'

  helpers do
    def data_current
      AccuweatherDatum.order(epoch_time: :desc).first
    end

    def halfhour_ago(time)
      Time.at(time).advance(minutes: -30).to_i
    end

    def halfhour_after(time)
      Time.at(time).advance(minutes: 30).to_i
    end
  end

  get '/current' do
    {
      epoch_time: data_current.epoch_time,
      temperature: data_current.temperature,
    }
  end

  params do
    requires :time, type: Integer, desc: 'Time for search.'
  end
  get '/by_time/:time' do
    record = AccuweatherDatum
               .where(epoch_time: halfhour_ago(params[:time])..halfhour_after(params[:time]))
               .select(:epoch_time, :temperature)
               .first

    if record.present?
      record.as_json(except: :id)
    else
      error!('Not Found', 404)
    end
  end
end
