require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'
require 'capybara/rspec'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # Mock Framework
    config.mock_with :rspec
    
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Include FactoryGirl syntax methods.
    config.include FactoryGirl::Syntax::Methods
  end
end

Spork.each_run do
  FactoryGirl.reload
  Dir[Rails.root.join('app/spec/support/*.rb')].each {|f| require f}
  
  # Uncomment the lines you will need to reload on each run.
  # The more you load the slower your tests will be.
  Dir[Rails.root.join('app/controllers/*.rb')].each {|f| require f}
  # Dir[Rails.root.join('app/helpers/*.rb')].each {|f| require f}  
  Dir[Rails.root.join('app/models/*.rb')].each {|f| require f}
  Dir[Rails.root.join('app/views/**/*.rb')].each {|f| require f}
  # Dir[Rails.root.join('app/config/*.rb')].each {|f| require f}
end