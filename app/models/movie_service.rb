require 'faraday'
require 'json'
require 'date'

class MovieService
  def initialize; end

  def self.make_request(endpoint)
    Faraday.get(endpoint)
  end

  def self.endpoints
    Services::RequestEndpoints.new.endpoints
  end

  def self.render_request(endpoint)
    Services::RenderRequest.new(endpoint).parse
  end
end
