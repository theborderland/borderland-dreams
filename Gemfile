source 'https://rubygems.org'

ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Jquery ui
gem 'jquery-ui-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# User management
gem 'devise'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use HAML for views
gem 'haml'

# Enable Facebook authentication.
gem 'omniauth-facebook'

# Manage app secrets
gem 'figaro'

# Admin backend
gem 'activeadmin', github: 'activeadmin'
gem 'cancan' # or cancancan
gem 'draper'
gem 'pundit'

# Image gallery
gem 'blueimp-gallery'

# Pagination
gem 'kaminari-bootstrap'
gem 'kaminari'

# Filtering
gem 'filterrific'

# Images at S3
gem 'paperclip'
gem 'aws-sdk', '< 2'
gem 'rmagick'

gem 'nokogiri'

group :production do
  # needed by herokus
  gem 'rails_12factor'
  # postgres
  gem 'pg'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # For environment vars
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Use rspec for testing the thing
  gem 'rspec-rails'

  # Use faker to get random test data
  gem 'faker'
end
