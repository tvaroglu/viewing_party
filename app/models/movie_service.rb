require 'faraday'
require 'json'
require 'date'

class MovieService
  def initialize; end

  def self.endpoints
    {
      holidays: 'https://date.nager.at/api/v1/Get/US/2021'
    }
  end

  def self.make_request(endpoint)
    Faraday.get(endpoint)
  end

  def self.render_request(endpoint)
    Services::RenderRequest.new(endpoint).parse
  end
end
