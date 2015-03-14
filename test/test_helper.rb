ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end
