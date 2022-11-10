# frozen_string_literal: true

class CreateAccuweatherData < ActiveRecord::Migration[7.0]
  def change
    create_table :accuweather_data do |t|
      t.integer :epoch_time, index: { unique: true }
      t.float :temperature

      t.timestamps
    end
  end
end
