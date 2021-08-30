module Services
  class SearchResults
    def initialize(search_criteria)
      @search_criteria = search_criteria
      @page_1_results = MovieFacade.render_request(MovieFacade.endpoints(@search_criteria)[:search]['1-20'])['results']
      @page_2_results = MovieFacade.render_request(MovieFacade.endpoints(@search_criteria)[:search]['21-40'])['results']
      @total_results = @page_1_results.concat(@page_2_results)
    end

    def results
      @total_results.map { |result| MovieFacade.movie(result) }
    end
  end
end
