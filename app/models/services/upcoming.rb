module Services
  class Upcoming
    def initialize
      @page_1_results = MovieFacade.render_request(MovieFacade.endpoints[:upcoming]['1-20'])['results']
      @page_2_results = MovieFacade.render_request(MovieFacade.endpoints[:upcoming]['21-40'])['results']
      @total_results = @page_1_results.concat(@page_2_results)
    end

    def results
      @total_results.map { |result| MovieFacade.movie(result) }
    end
  end
end
