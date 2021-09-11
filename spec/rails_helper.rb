# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'simplecov'
SimpleCov.start do
  add_filter 'app/channels/'
  add_filter 'app/controllers/application_controller'
  add_filter 'app/jobs/'
  add_filter 'app/mailers/'
  add_filter 'spec/'
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.before(:each, :type => :feature) do
    # hook for current_user method in ApplicationController:
    @admin = User.create!(email: 'admin@example.com', password: 'guest')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    # hook for GET /config endpoint:
    @config_blob = File.read('./spec/fixtures/config.json')
    @config_request = stub_request(:get, "https://api.themoviedb.org/3/configuration?api_key=#{@api_key}")
      .to_return(status: 200, body: @config_blob)
    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints[:config])
      .and_return(JSON.parse(@config_request.response.body))

    # hook for GET /popular endpoint:
    @popular_blob_page_1 = File.read('./spec/fixtures/most_popular/most_popular_page_1_response.json')
    @popular_blob_page_2 = File.read('./spec/fixtures/most_popular/most_popular_page_2_response.json')
    @popular_request_page_1 = stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=1")
      .to_return(status: 200, body: @popular_blob_page_1)
    @popular_request_page_2 = stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=2")
      .to_return(status: 200, body: @popular_blob_page_2)

    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints[:most_popular]['1-20'])
      .and_return(JSON.parse(@popular_request_page_1.response.body))
    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints[:most_popular]['21-40'])
      .and_return(JSON.parse(@popular_request_page_2.response.body))

    # hook for GET /upcoming endpoint:
    @upcoming_blob_page_1 = File.read('./spec/fixtures/upcoming/upcoming_page_1_response.json')
    @upcoming_blob_page_2 = File.read('./spec/fixtures/upcoming/upcoming_page_2_response.json')
    @upcoming_request_page_1 = stub_request(:get, "https://api.themoviedb.org/3/movie/upcoming?api_key=#{@api_key}&sort_by=popularity.desc&language=en&page=1")
      .to_return(status: 200, body: @upcoming_blob_page_1)
    @upcoming_request_page_2 = stub_request(:get, "https://api.themoviedb.org/3/movie/upcoming?api_key=#{@api_key}&sort_by=popularity.desc&language=en&page=2")
      .to_return(status: 200, body: @upcoming_blob_page_2)

    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints[:upcoming]['1-20'])
      .and_return(JSON.parse(@upcoming_request_page_1.response.body))
    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints[:upcoming]['21-40'])
      .and_return(JSON.parse(@upcoming_request_page_2.response.body))

    # hook for GET /search endpoint:
    @search_criteria = 'jack'

    @search_blob_page_1 = File.read('./spec/fixtures/search/search_page_1_response.json')
    @search_blob_page_2 = File.read('./spec/fixtures/search/search_page_2_response.json')
    @search_request_page_1 = stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=1")
      .to_return(status: 200, body: @search_blob_page_1)
    @search_request_page_2 = stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=2")
      .to_return(status: 200, body: @search_blob_page_2)

    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints(@search_criteria)[:search]['1-20'])
      .and_return(JSON.parse(@search_request_page_1.response.body))
    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints(@search_criteria)[:search]['21-40'])
      .and_return(JSON.parse(@search_request_page_2.response.body))

    # hook for GET /movie/{movie_id} endpoint:
    @movie_id = 75780

    @details_blob = File.read('./spec/fixtures/movie_details.json')
    @details_request = stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}?api_key=#{@api_key}")
      .to_return(status: 200, body: @details_blob)
    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints('', @movie_id)[:details][:movie])
      .and_return(JSON.parse(@details_request.response.body))

    @reviews_blob = File.read('./spec/fixtures/reviews.json')
    @reviews_request = stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}/reviews?api_key=#{@api_key}&language=en-US&page=1")
      .to_return(status: 200, body: @reviews_blob)
    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints('', @movie_id)[:details][:reviews])
      .and_return(JSON.parse(@reviews_request.response.body))

    @cast_blob = File.read('./spec/fixtures/cast.json')
    @cast_request = stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}/credits?api_key=#{@api_key}&language=en-US")
      .to_return(status: 200, body: @cast_blob)
    allow(MovieFacade).to receive(:render_request)
      .with(MovieFacade.endpoints('', @movie_id)[:details][:cast])
      .and_return(JSON.parse(@cast_request.response.body))
  end
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
