require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every '1h', first_in: '5s' do
  Rails.logger.info 'Update Accuweather!'
  UpdateAccuweatherData.call
end
