# Talisman

## Pupose:

This is a test application meant to develop tests that can be applied to other applications.

Specifically it will test the Devise functionality and provide base tests that can be used, and expanded on, in other applications with very little modification. The hope is that this will ease the process of testing Devise for the specific functionality desired. 

Also included are tests for using Cancan with Devise. Again the hope is provide base tests that can be used, and expanded on, in other applications with very little modification.

## Notes:

### Rspec: testing

  Add to the Gemfile in test and development groups: gem 'rspec-rails'
  In the command line: 
    bundle install
    rails g rspec:install
  If working on a windows platform remove --colour from .rspec to clean up messages.

### Capybara: simulate interactions with browser

  Add to the Gemfile in test group: gem 'capybara'
  In the command line: 
    bundle install
  In spec_helper.rb: require 'capybara/rspec'

### Spork: speed up running of tests

  Add to the Gemfile in test group: gem 'spork-rails'
  In the command line:
    bundle install
    spork rspec --bootstrap
  Setup spec_helper.rb with prefork and each_run blocks.

### Factory Girl: replaces fixtures with factories

  Add to the Gemfile in test group: gem 'factory_girl_rails', '~> 3.0'
  In the command line: 
    bundle install
  In spec_helper.rb include in the each_run block:
    FactoryGirl.reload
  Configure Rspec with syntax methods (in spec_helper.rb):
    Rspec.configure do |config|
      config.include FactoryGirl::Syntax::Methods
    end
  Create spec/support directory.
    Create factories.rb and use it to define factories.

### Simple form: simplify forms

  Add to the Gemfile: gem 'simple_form'
  In the command line:
    bundle install
    rails g simple_form:install --bootstrap
  Change form_for to simple_form_for to use with form.

### Devise: authentication
  
  Add to the Gemfile: gem 'devise'
  Optional: Add to Gemfile if you want custom encryptors: gem 'devise-encryptable'
  In the command line:
    bundle install
    rails g devise:install
  Configure devise and application as specified.
  Use the following command to generate models with devise.
    rails g devise <model_name>
    rake db:migrate
  Use the following command to generate scoped views.
    rails g devise:views <model_name>