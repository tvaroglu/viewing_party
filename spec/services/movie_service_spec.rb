require 'rails_helper'

RSpec.describe MovieService do
  before :each do
    if Rails.application.credentials.movie_db.nil?
      @api_key = ''
      allow_any_instance_of(Services::RequestEndpoints).to receive(:key).and_return(@api_key)
    end
  end

  it 'exists' do
    api = MovieService.new

    expect(api.class).to eq(MovieService)
  end

  describe 'endpoints' do
    it 'can retrieve endpoints for top 40 most popular movies API calls' do
      expected = MovieService.endpoints[:most_popular]

      expect(expected.class).to eq(Hash)

      expect(expected.keys.length).to eq(2)
      expect(expected.values.length).to eq(2)
      expect(expected.keys.first).to eq('1-20')
      expect(expected.keys.last).to eq('21-40')
    end
    it 'can retrieve endpoints for up to 40 movies matching a search criteria' do
      expected = MovieService.endpoints[:search]

      expect(expected.class).to eq(Hash)

      expect(expected.keys.length).to eq(2)
      expect(expected.values.length).to eq(2)
      expect(expected.keys.first).to eq('1-20')
      expect(expected.keys.last).to eq('21-40')
    end
  end

  it 'can render API requests via Faraday' do
    mock_response = "{\"login\":\"tvaroglu\",\"id\":12345678,\"url\":\"https://api.github.com/users/tvaroglu\"}"
    allow(Faraday).to receive(:get).and_return(mock_response)

    expected = MovieService.render_request(MovieService.endpoints[:most_popular]['1-20'])
    expect(expected['login']).to eq('tvaroglu')
  end

  describe 'helper methods' do
    it 'can return the top 40 most popular movies' do
      json_blob_page_1 = File.read('./spec/fixtures/most_popular/most_popular_page_1_response.json')
      json_blob_page_2 = File.read('./spec/fixtures/most_popular/most_popular_page_2_response.json')
      webmock_request_page_1 = stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=1").
        to_return(status: 200, body: json_blob_page_1)
      webmock_request_page_2 = stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=2").
        to_return(status: 200, body: json_blob_page_2)

      allow(MovieService).to receive(:make_request).and_return(webmock_request_page_1.response.body)
      page_1_endpoint = MovieService.endpoints[:most_popular]['1-20']
      page_1_response = MovieService.render_request(page_1_endpoint)
      expect(page_1_response['results'].length).to eq(20)

      allow(MovieService).to receive(:make_request).and_return(webmock_request_page_2.response.body)
      page_2_endpoint = MovieService.endpoints[:most_popular]['21-40']
      page_2_response = MovieService.render_request(page_2_endpoint)
      expect(page_2_response['results'].length).to eq(20)
    end

    it 'can return up to 40 movies matching a passed in search criteria' do
      @search_criteria = 'jack'

      json_blob_page_1 = File.read('./spec/fixtures/search/search_page_1_response.json')
      json_blob_page_2 = File.read('./spec/fixtures/search/search_page_2_response.json')
      webmock_request_page_1 = stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=1").
        to_return(status: 200, body: json_blob_page_1)
      webmock_request_page_2 = stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=2").
        to_return(status: 200, body: json_blob_page_2)

      allow(MovieService).to receive(:make_request).and_return(webmock_request_page_1.response.body)
      page_1_endpoint = MovieService.endpoints(@search_criteria)[:search]['1-20']
      page_1_response = MovieService.render_request(page_1_endpoint)
      expect(page_1_response['results'].length).to eq(20)

      allow(MovieService).to receive(:make_request).and_return(webmock_request_page_2.response.body)
      page_2_endpoint = MovieService.endpoints(@search_criteria)[:search]['21-40']
      page_2_response = MovieService.render_request(page_2_endpoint)
      expect(page_2_response['results'].length).to eq(20)

      expect(MovieService.search_results(@search_results).length).to eq(40)
    end

    it 'can return movies details for a specific movie' do
      @movie_id = 75780

      json_blob = File.read('./spec/fixtures/movie_details.json')
      webmock_request = stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}?api_key=#{@api_key}").
        to_return(status: 200, body: json_blob)

      allow(MovieService).to receive(:make_request).and_return(webmock_request.response.body)
      request_endpoint = MovieService.endpoints('', @movie_id)[:details]
      response = MovieService.render_request(request_endpoint)
      expect(response.class).to eq(Hash)
    end
  end

end
