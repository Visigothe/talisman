source 'https://rubygems.org'

# Framework
gem 'rails', '3.2.10'
gem 'jquery-rails'

# Database
gem 'pg'

# Server
gem 'thin'

# Authentication
gem 'devise'
gem 'devise-encryptable'

# Authorization
gem 'cancan'

# Styling
gem 'bootstrap-sass'
gem 'simple_form'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

# Test suite
group :development, :test do
  gem 'rspec-rails', '~> 2.12.2'
  gem 'factory_girl_rails', '~> 4.2.0'
  gem 'guard-rspec', '~> 2.4.0'
  gem 'guard-spork', '~> 1.5.0'
  gem 'spork-rails', '~> 3.2.0'
end

group :test do
  gem 'ffaker', '~> 1.15.0'
  gem 'capybara', '~> 2.0.2'
  gem 'database_cleaner', '~> 0.9.1'
end

# Misc
group :test, :development do
  gem 'annotate', '>=2.5.0.pre1'
end
