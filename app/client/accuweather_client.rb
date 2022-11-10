# frozen_string_literal: true

# :nodoc:
class AccuweatherClient
  include JsonApiClient

  ACCUWEATHER_URL = 'http://dataservice.accuweather.com/currentconditions/v1/327146/historical/24'

  def initialize(apikey)
    @apikey = apikey
  end

  def historical_current_conditions
    parse_json http_request(ACCUWEATHER_URL, { apikey: @apikey })
  end
end
