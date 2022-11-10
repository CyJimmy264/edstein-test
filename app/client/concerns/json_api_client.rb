# frozen_string_literal: true

# JSON API Client's common methods
module JsonApiClient
  private

  def http_request(url, params = {})
    response = Faraday.new.get do |request|
      request.url url
      params.each do |(key, value)|
        request.params[key] = value
      end
    end

    raise HTTPError, "Invalid HTTP status: #{response.status}" unless response.status == 200

    response.body
  rescue Faraday::ClientError => e
    raise HTTPError, e.message
  end

  def parse_json(str)
    JSON.parse str
  rescue StandardError => e
    raise JSONError, e.message
  end

  class Error < RuntimeError; end
  class HTTPError   < Error; end
  class JSONError   < Error; end
end
