module Services
  class RequestEndpoints
    def initialize(search_criteria, movie_id)
      @search_criteria = search_criteria
      @movie_id = movie_id
      @api_key = key
      @base_url = 'https://api.themoviedb.org/3'
      @sort_criteria = 'popularity.desc'
    end

    def collection
      {
        most_popular:
        {
          '1-20' => "#{@base_url}/discover/movie?api_key=#{@api_key}&sort_by=#{@sort_criteria}&page=1",
          '21-40' => "#{@base_url}/discover/movie?api_key=#{@api_key}&sort_by=#{@sort_criteria}&page=2"
        },
        upcoming:
        {
          '1-20' => "#{@base_url}/movie/upcoming?api_key=#{@api_key}&sort_by=#{@sort_criteria}&language=en&page=1",
          '21-40' => "#{@base_url}/movie/upcoming?api_key=#{@api_key}&sort_by=#{@sort_criteria}&language=en&page=2"
        },
        search:
        {
          '1-20' => "#{@base_url}/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=#{@sort_criteria}&page=1",
          '21-40' => "#{@base_url}/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=#{@sort_criteria}&page=2"
        },
        details:
        {
          movie: "#{@base_url}/movie/#{@movie_id}?api_key=#{@api_key}",
          reviews: "#{@base_url}/movie/#{@movie_id}/reviews?api_key=#{@api_key}&language=en-US&page=1",
          cast: "#{@base_url}/movie/#{@movie_id}/credits?api_key=#{@api_key}&language=en-US"
        },
        config: "#{@base_url}/configuration?api_key=#{@api_key}"
      }
    end

    private

    def key
      Rails.application.credentials.movie_db.values.last
    end
  end
end
