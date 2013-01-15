# This script is designed to be used with Ruby on Rails' new project generator:
#
#     rails new my_app -m  path_to_this_file.rb
#
# For more information about the template API, please see the following Rails
# guide:
#
#     http://edgeguides.rubyonrails.org/rails_application_templates.html

puts "starting generation for #{app_name}"

run "rm -R test"
run "rm public/index.html"

file '.rvmrc', "rvm 1.9.3@#{app_name} --create"
# Picked from https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/extras.rb
if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  begin
    gems_path = ENV['MY_RUBY_HOME'].split(/@/)[0].sub(/rubies/,'gems')
    ENV['GEM_PATH'] = "#{gems_path}:#{gems_path}@global"
    require 'rvm'
    RVM.use_from_path! File.dirname(File.dirname(__FILE__))
  rescue LoadError
    raise "RVM gem is currently unavailable."
  end
end
puts "creating RVM gemset '#{app_name}'"
RVM.gemset_create app_name
run "rvm rvmrc trust"
puts "switching to gemset '#{app_name}'"
# RVM.gemset_use! requires rvm version 1.11.3.5 or newer
rvm_spec =
  if Gem::Specification.respond_to?(:find_by_name)
    Gem::Specification.find_by_name("rvm")
  else
    Gem.source_index.find_name("rvm").last
  end
  unless rvm_spec.version > Gem::Version.create('1.11.3.4')
    puts "rvm gem version: #{rvm_spec.version}"
    raise "Please update rvm gem to 1.11.3.5 or newer"
  end
begin
  RVM.gemset_use! app_name
rescue => e
  puts "rvm failure: unable to use gemset #{app_name}, reason: #{e}"
  raise
end
run "rvm gemset list"

# before adding project to the repo, we remove sensitive data. e.g. the secret token
gsub_file 'config/initializers/secret_token.rb', /secret_token *= *'.+'/, "secret_token = ENV['APP_SECRET_TOKEN']"

git :init
git add: "."
git commit: %Q{ -m 'Initial commit, plain rails app' }

# Install required gems
gem "active_model_serializers"
gem "slim-rails"
gem "figaro"

gem_group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'quiet_assets'
end

gem_group :test do
  gem 'webmock'
  gem 'vcr'
end

gem_group :assets do
  gem 'libv8', '3.11.8.3'
  gem 'therubyracer', '0.11.0beta5'
  gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
  gem 'less-rails'
end

run "bundle install"
generate 'bootstrap:install less'
generate 'figaro:install'

# add secret token in ignored application.yml file.
append_to_file 'config/application.yml', "APP_SECRET_TOKEN: #{SecureRandom.hex(64)}"

git add: "."
git commit: %Q{ -m 'Adding usefull gems' }


# =======================================
# = Add and configure rspec and friends =
# =======================================
generate 'rspec:install'
FileUtils.mkdir 'spec/support'
FileUtils.mkdir 'spec/vcr_cassettes'

file 'spec/support/vcr.rb', <<-CODE
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.ignore_localhost = true
end
CODE

git add: "."
git commit: %Q{ -m 'The spec and VCR configuration' }


gem 'angular-rails'
run "bundle install"
generate 'angular:install'

git add: "."
git commit: %Q{ -m 'The angular generator' }


route "root to: 'main#index'"

generate 'controller main index'

remove_file 'app/views/main/index.html.slim'
file 'app/views/main/index.html.slim', <<-CODE
CODE

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.slim', <<-CODE
doctype html
html
  head
    meta charset="utf-8"
    title= @app_name.titleize rescue 'app'
    = stylesheet_link_tag 'application', media: 'all'
    = csrf_meta_tags
  body{ng-app}
    .navbar.navbar-fixed-top
      .navbar-inner
        .container
          a.brand href='/'
            = @app_name.titleize rescue 'app'
    .container
      = render 'layouts/flash'
      .content
        = yield
    = javascript_include_tag 'application'
CODE


git add: %Q{ -A '.' }
git commit: %Q{ -m 'Main controller and layout' }



# Generate a default serializer that is compatible with JS frameworks
generate :serializer, "application", "--parent", "ActiveModel::Serializer"
inject_into_class "app/serializers/application_serializer.rb", 'ApplicationSerializer' do
  "  embed :ids, :include => true\n"
end
git add: %Q{ -A '.' }
git commit: %Q{ -m 'Generating serializer' }


# =============================
# = Authentication + database =
# =============================

gem 'couchrest_model'

run "bundle install"
generate 'couchrest_model:config'

git add: %Q{ -A '.'}
git commit: %Q{ -m 'Config for couchrest'}
