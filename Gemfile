source 'http://rubygems.org'
ruby '1.9.3'
if RUBY_VERSION =~ /1.9/
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8
end
gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3', group: [:development, :test]
gem 'pg', group: :production

# Gems used only for assets and not required
# in production environments by default.
gem "libv8", "3.11.8.3"
gem "therubyracer", "0.11.0beta5"
gem "less-rails"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem "twitter-bootstrap-rails", :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem "active_model_serializers"
gem "slim-rails"
gem "figaro"
group :test, :development do
  gem "factory_girl_rails"
  gem "rspec-rails"
  gem "quiet_assets"
  gem 'jasminerice'
end

group :test do
  gem "webmock"
  gem "vcr"
end

gem "angular-rails"
gem "couchrest_model"