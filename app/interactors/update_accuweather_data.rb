# frozen_string_literal: true

# :nodoc:
class UpdateAccuweatherData
  include Interactor

  def call
    Rails.logger.info 'Updating Accuweather Data'

    accuweather_client.historical_current_conditions.reverse_each do |data|
      update_record(data)
    end
  rescue StandardError => e
    Rails.logger.error "Exception #{e.inspect}"
  end

  def update_record(data)
    temp = data.dig('Temperature', 'Metric', 'Value')

    record = AccuweatherDatum.create_with(temperature: temp)
               .find_or_create_by!(epoch_time: data['EpochTime'])

    return if record.temperature == temp

    record.temperature = temp
    record.save!
  end

  def accuweather_client
    @accuweather_client ||=
      AccuweatherClient.new(Rails.application.credentials.accuweather_apikey)
  end
end
