source 'https://rubygems.org'

# Allow to use github without bundle audit complaining about insecure sources
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'rails', '~> 4.2.6'

# Maestrano Enterprise Engine
# Bundle edge Mnoe instead:
gem 'mno-enterprise', git: 'https://github.com/maestrano/mno-enterprise', branch: '4.0'

# Use local mnoe
# gem 'mno-enterprise', path: '../mno-enterprise'

gem 'intercom', '~> 3.5.4'

# Use puma as the app server
gem 'puma', require: false

# Redis cache
gem 'redis-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Background Jobs
gem 'sucker_punch', '~> 2.0'

# Ops gems
group :sit, :uat, :production do
  gem 'newrelic_rpm'
  gem 'rails_stdout_logging' # For Nex! logs
  gem 'nex_client', '~> 0.17'
end

# CI gems
group :development do
  # Security audits
  gem 'brakeman', '~> 4.1.0', require: false
  gem 'bundler-audit', require: false

  # Style check
  gem 'rubocop', '~> 0.52.0', require: false
  gem 'rubocop-rspec', require: false
end

group :development, :test do
  gem 'figaro'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'

  # Code coverage
  gem 'simplecov'
end
