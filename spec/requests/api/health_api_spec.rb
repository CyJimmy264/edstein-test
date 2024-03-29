# frozen_string_literal: true

require 'swagger_helper'

describe 'Health API' do
  path '/health' do
    get 'Retrieves a health' do
      tags 'Health'
      produces 'application/json'

      response '200', 'Weather API service status should be OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
               }
        run_test!
      end
    end
  end
end
