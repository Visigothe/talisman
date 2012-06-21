source 'https://rubygems.org'

# Base
gem 'rails', '3.2.6'
gem 'thin'
gem 'jquery-rails'
gem 'pg'

# Authentication
gem 'devise'
gem 'devise-encryptable'

# Authorization
gem 'cancan'

# Utilities
# gem 'friendly_id', '~> 4.0.1'
	# Slug and permalink plugin for ActiveRecord

# Assets (a.k.a. misc)
gem 'bootstrap-sass', '~> 2.0.3'
	# Includes Compass support
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'simple_form'
# gem 'rails3-jquery-autocomplete'
	# Project must use jQuery-UI and the autocomplete widget
# gem 'execjs'
	# Chooses the best runtime for optimal results
# group :production do
# 	gem 'therubyracer', platforms: :ruby
# end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  # gem 'compass-rails'
  	# Adapter for Compass for Rails
  	# Installs Compass into Rails application
	# gem 'compass-colors'
		# Support for working with colors in Sass and generating color themes 
	# gem 'fancy-buttons'
		# Support for CSS buttons using Compass 
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'annotate', '>=2.5.0.pre1'
  # gem 'ci_reporter'
  	# Addon to Rspec to generate XML resports for spec runs.
end

group :test do 
  gem 'spork-rails'
  gem 'capybara'
  gem 'rb-notifu'
  gem 'rb-fchange'
  gem 'win32console'
  gem 'factory_girl_rails', '~> 3.0'
end
