class MovieFacade
  class << self
    def endpoints(search_criteria = nil, movie_id = nil)
      Services::RequestEndpoints.new(search_criteria, movie_id).collection
    end

    def render_request(endpoint)
      Services::RenderRequest.new(endpoint).parse
    end

    def most_popular
      Services::MostPopular.new.results
    end

    def upcoming
      Services::Upcoming.new.results
    end

    def search_results(search_criteria)
      Services::SearchResults.new(search_criteria).results
    end

    def movie_details(movie_id)
      Services::MovieDetails.new(movie_id).details
    end

    def movie_reviews(movie_id)
      Services::MovieDetails.new(movie_id).reviews
    end

    def movie_cast(movie_id)
      Services::MovieDetails.new(movie_id).cast
    end

    def movie(attributes)
      Services::Movie.new(attributes).hash
    end

    def review(attributes)
      Services::Review.new(attributes).hash
    end

    def cast_member(attributes)
      Services::CastMember.new(attributes).hash
    end

    def config
      Services::Config.new.hash
    end
  end
end
