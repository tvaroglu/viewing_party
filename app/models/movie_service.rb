require 'faraday'
require 'json'
require 'date'

class MovieService
  def initialize; end

  def self.make_request(endpoint)
    Faraday.get(endpoint)
  end

  def self.endpoints(search_criteria = nil, movie_id = nil)
    Services::RequestEndpoints.new(search_criteria, movie_id).collection
  end

  def self.render_request(endpoint)
    Services::RenderRequest.new(endpoint).parse
  end
end
