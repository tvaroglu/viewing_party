module Services
  class RequestEndpoints
    def initialize(search_criteria, movie_id)
      @search_criteria = search_criteria
      @movie_id = movie_id
      @api_key = key
    end

    def collection
      {
        most_popular:
        {
          '1-20' => "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=1",
          '21-40' => "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=2"
        },
        search:
        {
          '1-20' => "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=1",
          '21-40' => "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=2"
        },
        details:
        {
          movie: "https://api.themoviedb.org/3/movie/#{@movie_id}?api_key=#{@api_key}",
          reviews: "https://api.themoviedb.org/3/movie/#{@movie_id}/reviews?api_key=#{@api_key}&language=en-US&page=1",
          cast: "https://api.themoviedb.org/3/movie/#{@movie_id}/credits?api_key=#{@api_key}&language=en-US"
        },
        config: "https://api.themoviedb.org/3/configuration?api_key=#{@api_key}"
      }
    end

    private

    def key
      Rails.application.credentials.movie_db.values.last
    end
  end
end
