module Services
  class RequestEndpoints
    def initialize(api_key = '', search_criteria)
      @api_key = key
      @search_criteria = search_criteria
    end

    def endpoints
      {
        most_popular:
        {
          '1-20' => "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=1",
          '21-40' => "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=2"
        },
        search:
        {
          '1-20' => "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&page=1",
          '21-20' => "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&page=2",
        }
      }
    end

    private

    def key
      Rails.application.credentials.movie_db.nil? ? '' : Rails.application.credentials.movie_db.values.last
    end
  end
end
