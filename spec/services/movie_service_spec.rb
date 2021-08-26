require 'rails_helper'

RSpec.describe MovieService do
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
    xit 'can return the top 40 most popular movies' do
      # 1.) Need to stub the 'render_request' method with a mock response to keep test light-weight
      # 2.) Need to add expectations to test the helper method (TBD) that aggregates the top 40 movies
        # Awaiting additional feedback via Slack if anyone found a way to call 40 movies in one request..
      page_1_endpoint = MovieService.endpoints[:most_popular]['1-20']
      page_2_endpoint = MovieService.endpoints[:most_popular]['21-40']

      page_1_response = MovieService.render_request(page_1_endpoint)['results']
      page_2_response = MovieService.render_request(page_2_endpoint)['results']
      require "pry"; binding.pry
    end

    xit 'can return up to 40 movies matching a passed in search criteria' do
      # endpoints = MovieService.endpoints('Jack+Reacher')[:search]
      page_1_endpoint = MovieService.endpoints('jack')[:search]['1-20']
      page_2_endpoint = MovieService.endpoints('jack')[:search]['21-40']

      page_1_response = MovieService.render_request(page_1_endpoint)['results']
      page_2_response = MovieService.render_request(page_2_endpoint)['results']
      require "pry"; binding.pry
    end
  end

end
