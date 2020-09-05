# frozen_string_literal: true

require 'dotenv'
Dotenv.overload '.env.test'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/pride'
require 'minitest/autorun'
require 'minitest/profile'

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
end
