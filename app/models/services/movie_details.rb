module Services
  class MovieDetails
    def initialize(movie_id)
      @movie_id = movie_id
      @movie_details_response = MovieFacade.render_request(MovieFacade.endpoints('', @movie_id)[:details][:movie])
      @movie_reviews_response = MovieFacade.render_request(MovieFacade.endpoints('', @movie_id)[:details][:reviews])
      @movie_cast_response = MovieFacade.render_request(MovieFacade.endpoints('', @movie_id)[:details][:cast])
      @movie_details_hash = Hash.new('')
    end

    def genres
      @movie_details_response['genres'].map { |genre| genre.values[1] }.to_s[1..-2]
    end

    def details
      if !@movie_details_response['id'].nil?
        @movie_details_hash[:id] = @movie_details_response['id']
        @movie_details_hash[:title] = @movie_details_response['title']
        @movie_details_hash[:runtime] = @movie_details_response['runtime']
        @movie_details_hash[:vote_average] = @movie_details_response['vote_average']
        @movie_details_hash[:genres] = genres
        @movie_details_hash[:overview] = @movie_details_response['overview']
        @movie_details_hash[:poster_path] = @movie_details_response['poster_path']
      end
      @movie_details_hash
    end

    def reviews
      @movie_reviews_response['results'].map { |response_object| MovieFacade.review(response_object) } if @movie_reviews_response['results']
    end

    def cast
      @movie_cast_response['cast'][0..9].map { |response_object| MovieFacade.cast_member(response_object) } if @movie_cast_response['cast']
    end
  end
end
