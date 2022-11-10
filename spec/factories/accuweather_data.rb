# frozen_string_literal: true

FactoryBot.define do
  factory :accuweather_datum do
    epoch_time { 1668082357 }
    temperature { 1.5 }
  end
end
