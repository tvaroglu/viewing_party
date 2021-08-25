module Services
  class RequestEndpoints
    def initialize(api_key='')
      @api_key = key
    end

    def endpoints
      {
        most_popular:
        {
          '1-20' => "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=1",
          '21-40' => "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=2",
        }
      }
    end

    private
    def key
      Rails.application.credentials.movie_db.values.last
    end
  end
end
