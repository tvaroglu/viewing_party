require 'rails_helper'

RSpec.describe MovieService do
  it 'exists' do
    api = MovieService.new

    expect(api.class).to eq(MovieService)
  end

  describe 'Nager Date APIs' do
    it 'can retrieve the public holidays endpoint for API calls' do
      expect(MovieService.endpoints[:holidays]).to eq('https://date.nager.at/api/v1/Get/US/2021')
    end

    it 'can initialize the public holidays endpoint to request a JSON response' do
      expected = Services::RenderRequest.new(MovieService.endpoints[:holidays])
      expect(expected.endpoint.class).to eq(String)
    end

    xit 'can return a JSON response from the API endpoint' do
      expected = MovieService.render_request(MovieService.endpoints[:holidays])
      expect(expected.class).to eq Array
    end
  end

end
