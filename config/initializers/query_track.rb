# frozen_string_literal: true

if ENV['RAILS_ENV'] == 'development'
  QueryTrack::Settings.configure do |config|
    config.duration = 0.5
    config.logs = true
  end
end
