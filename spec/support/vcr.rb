# frozen_string_literal: true

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.ignore_request { ENV.fetch('DISABLE_VCR', nil) }
  config.ignore_localhost = true
  config.default_cassette_options = { record: :once }

  config.configure_rspec_metadata!

  config.filter_sensitive_data('<ACCUWEATHER_APIKEY>') { Rails.application.credentials.accuweather_apikey }
end
