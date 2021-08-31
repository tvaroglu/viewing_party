require 'faraday'
require 'json'
require 'date'

class MovieFacade
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

  def self.most_popular
    Services::MostPopular.new.results
  end

  def self.search_results(search_criteria)
    Services::SearchResults.new(search_criteria).results
  end

  def self.movie_details(movie_id)
    Services::MovieDetails.new(movie_id).details
  end

  def self.movie(attributes)
    Services::Movie.new(attributes).hash
  end
end
