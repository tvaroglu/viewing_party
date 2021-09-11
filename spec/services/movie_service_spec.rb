require 'rails_helper'

RSpec.describe MovieFacade do
  before :each do
    if Rails.application.credentials.movie_db.nil?
      let(:api_key) { '' }
      allow_any_instance_of(Services::RequestEndpoints).to receive(:v3_key).and_return(api_key)
    end
  end

  describe 'endpoints' do
    it 'can retrieve the endpoint for config details' do
      expected = MovieFacade.endpoints[:config]

      expect(expected.class).to eq String
    end

    it 'can retrieve the endpoint for top 40 most popular movies API calls' do
      expected = MovieFacade.endpoints[:most_popular]

      expect(expected.class).to eq Hash

      expect(expected.keys.length).to eq 2
      expect(expected.values.length).to eq 2
      expect(expected.keys.first).to eq '1-20'
      expect(expected.keys.last).to eq '21-40'
    end

    it 'can retrieve the endpoint for top 40 upcoming movies API calls' do
      expected = MovieFacade.endpoints[:upcoming]

      expect(expected.class).to eq Hash

      expect(expected.keys.length).to eq 2
      expect(expected.values.length).to eq 2
      expect(expected.keys.first).to eq '1-20'
      expect(expected.keys.last).to eq '21-40'
    end

    it 'can retrieve the endpoints for up to 40 movies matching a search criteria' do
      expected = MovieFacade.endpoints[:search]

      expect(expected.class).to eq Hash

      expect(expected.keys.length).to eq 2
      expect(expected.values.length).to eq 2
      expect(expected.keys.first).to eq '1-20'
      expect(expected.keys.last).to eq '21-40'
    end

    it 'can retrieve the endpoints for movie details' do
      expected = MovieFacade.endpoints[:details]

      expect(expected.class).to eq Hash

      expect(expected.keys.length).to eq 3
      expect(expected.keys[0]).to eq :movie
      expect(expected.keys[1]).to eq :reviews
      expect(expected.keys[2]).to eq :cast
      expect(expected.values.length).to eq 3
    end
  end

  describe 'helper methods' do
    # stubs for GET /config endpoint:
    let(:config_blob) { File.read('./spec/fixtures/config.json') }
    let(:config_request) { stub_request(:get, "https://api.themoviedb.org/3/configuration?api_key=#{@api_key}")
      .to_return(status: 200, body: config_blob) }

    # stubs for GET /popular endpoint:
    let(:popular_blob_page_1) { File.read('./spec/fixtures/most_popular/most_popular_page_1_response.json') }
    let(:popular_blob_page_2) { File.read('./spec/fixtures/most_popular/most_popular_page_2_response.json') }
    let(:popular_request_page_1) { stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=1")
      .to_return(status: 200, body: popular_blob_page_1) }
    let(:popular_request_page_2) { stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=2")
      .to_return(status: 200, body: popular_blob_page_2) }

    # stubs for GET /upcoming endpoint:
    let(:upcoming_blob_page_1) { File.read('./spec/fixtures/upcoming/upcoming_page_1_response.json') }
    let(:upcoming_blob_page_2) { File.read('./spec/fixtures/upcoming/upcoming_page_2_response.json') }
    let(:upcoming_request_page_1) { stub_request(:get, "https://api.themoviedb.org/3/movie/upcoming?api_key=#{@api_key}&sort_by=popularity.desc&language=en&page=1")
      .to_return(status: 200, body: upcoming_blob_page_1) }
    let(:upcoming_request_page_2) { stub_request(:get, "https://api.themoviedb.org/3/movie/upcoming?api_key=#{@api_key}&sort_by=popularity.desc&language=en&page=2")
      .to_return(status: 200, body: upcoming_blob_page_2) }

    # stubs for GET /search endpoint:
    let(:search_criteria) { 'jack' }
    let(:search_blob_page_1) { File.read('./spec/fixtures/search/search_page_1_response.json') }
    let(:search_blob_page_2) { File.read('./spec/fixtures/search/search_page_2_response.json') }
    let(:search_request_page_1) { stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{search_criteria}&sort_by=popularity.desc&page=1")
      .to_return(status: 200, body: search_blob_page_1) }
    let(:search_request_page_2) { stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{search_criteria}&sort_by=popularity.desc&page=2")
      .to_return(status: 200, body: search_blob_page_2) }

    # stubs for GET /movie/{movie_id} endpoint:
    let(:movie_id) { 75780 }
    let(:details_blob) { File.read('./spec/fixtures/movie_details.json') }
    let(:details_request) { stub_request(:get, "https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{@api_key}")
      .to_return(status: 200, body: details_blob) }
    let(:reviews_blob) { File.read('./spec/fixtures/reviews.json') }
    let(:reviews_request) { stub_request(:get, "https://api.themoviedb.org/3/movie/#{movie_id}/reviews?api_key=#{@api_key}&language=en-US&page=1")
      .to_return(status: 200, body: reviews_blob) }
    let(:cast_blob) { File.read('./spec/fixtures/cast.json') }
    let(:cast_request) { stub_request(:get, "https://api.themoviedb.org/3/movie/#{movie_id}/credits?api_key=#{@api_key}&language=en-US")
      .to_return(status: 200, body: cast_blob) }

    it 'can return config details to render an image' do
      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints[:config])
        .and_return(JSON.parse(config_request.response.body))

      expected = MovieFacade.config

      expect(expected.class).to eq Hash
      expect(!expected[:secure_base_url].nil?).to be true
      expect(expected[:poster_size]).to eq 'w500'
    end

    it 'can return the top 40 most popular movies' do
      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints[:most_popular]['1-20'])
        .and_return(JSON.parse(popular_request_page_1.response.body))

      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints[:most_popular]['21-40'])
        .and_return(JSON.parse(popular_request_page_2.response.body))

      expected = MovieFacade.most_popular
      expect(expected.length).to eq 40

      expected.each do |expectation|
        expectation.class == Hash
        !expectation[:id].nil?
        !expectation[:title].nil?
        !expectation[:vote_average].nil?
      end
    end

    it 'can return the top 40 upcoming movies' do
      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints[:upcoming]['1-20'])
        .and_return(JSON.parse(upcoming_request_page_1.response.body))

      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints[:upcoming]['21-40'])
        .and_return(JSON.parse(upcoming_request_page_2.response.body))

      expected = MovieFacade.upcoming
      expect(expected.length).to eq 40

      expected.each do |expectation|
        expectation.class == Hash
        !expectation[:id].nil?
        !expectation[:title].nil?
        !expectation[:vote_average].nil?
      end
    end

    it 'can return up to 40 movies matching a passed in search criteria' do
      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints(search_criteria)[:search]['1-20'])
        .and_return(JSON.parse(search_request_page_1.response.body))
      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints(search_criteria)[:search]['21-40'])
        .and_return(JSON.parse(search_request_page_2.response.body))

      expected = MovieFacade.search_results(search_criteria)
      expect(expected.length).to eq 40

      expected.each do |expectation|
        expectation.class == Hash
        !expectation[:id].nil?
        !expectation[:title].nil?
        !expectation[:vote_average].nil?
        !expectation[:poster_path].nil?
      end
    end

    it 'can return movies details for a specific movie' do
      # movie details
      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints('', movie_id)[:details][:movie])
        .and_return(JSON.parse(details_request.response.body))
      # movie reviews
      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints('', movie_id)[:details][:reviews])
        .and_return(JSON.parse(reviews_request.response.body))
      # movie cast
      allow(MovieFacade).to receive(:render_request)
        .with(MovieFacade.endpoints('', movie_id)[:details][:cast])
        .and_return(JSON.parse(cast_request.response.body))

      details = MovieFacade.movie_details(movie_id)

      expect(details.class).to eq Hash
      expect(!details[:id].nil?).to be true
      expect(!details[:title].nil?).to be true
      expect(!details[:runtime].nil?).to be true
      expect(!details[:vote_average].nil?).to be true
      expect(!details[:genres].nil?).to be true
      expect(!details[:overview].nil?).to be true
      expect(!details[:poster_path].nil?).to be true

      reviews = MovieFacade.movie_reviews(movie_id)
      expect(reviews.class).to eq Array
      reviews.each do |expectation|
        expectation.class == Hash
        !expectation[:id].nil?
        !expectation[:author].nil?
        !expectation[:content].nil?
      end

      cast = MovieFacade.movie_cast(movie_id)
      expect(cast.class).to eq Array
      cast.each do |expectation|
        expectation.class == Hash
        !expectation[:id].nil?
        !expectation[:name].nil?
        !expectation[:character].nil?
      end
    end
  end

end
