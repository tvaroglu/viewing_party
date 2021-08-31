module Services
  class MovieDetails
    def initialize(movie_id)
      @movie_id = movie_id
      @result = MovieFacade.render_request(MovieFacade.endpoints('', @movie_id)[:details])
      @attributes_hash = Hash.new('')
    end

    def genres
      collection_arr = Array.new
      if !@result['id'].nil?
        @result['genres'].each do |genre|
          collection_arr << genre.values[1]
        end
      end
      collection_arr
    end

    def details
      if !@result['id'].nil?
        @attributes_hash[:id] = @result['id']
        @attributes_hash[:title] = @result['title']
        @attributes_hash[:runtime] = @result['runtime']
        @attributes_hash[:vote_average] = @result['vote_average']
        @attributes_hash[:genres] = genres
        @attributes_hash[:overview] = @result['overview']
      end
      @attributes_hash
    end
  end
end
