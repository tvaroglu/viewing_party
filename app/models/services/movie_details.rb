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
      collection_arr = Array.new
      if !@movie_details_response['id'].nil?
        @movie_details_response['genres'].each do |genre|
          collection_arr << genre.values[1]
        end
      end
      collection_arr
    end

    def details
      if !@movie_details_hash['id'].nil?
        @movie_details_hash[:id] = @movie_details_response['id']
        @movie_details_hash[:title] = @movie_details_response['title']
        @movie_details_hash[:runtime] = @movie_details_response['runtime']
        @movie_details_hash[:vote_average] = @movie_details_response['vote_average']
        @movie_details_hash[:genres] = genres
        @movie_details_hash[:overview] = @movie_details_response['overview']
      end
      @movie_details_hash
    end

    def reviews
      @movie_reviews_response['results'].map { |response_object| MovieFacade.review(response_object) }
    end

    def cast
      @movie_cast_response['cast'][0..9].map { |response_object| MovieFacade.cast_member(response_object) }
    end
  end
end
