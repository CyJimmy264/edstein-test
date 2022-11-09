# frozen_string_literal: true

class ApplicationApi < Grape::API
  format :json
  mount HealthApi
end
