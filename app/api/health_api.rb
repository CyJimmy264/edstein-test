# frozen_string_literal: true

# :nodoc:
class HealthApi < Grape::API
  get '/health' do
    { status: 'OK' }
  end
end
