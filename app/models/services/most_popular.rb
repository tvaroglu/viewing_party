module Services
  class MostPopular
    def initialize; end

    def results
      page_1_results = MovieService.render_request(MovieService.endpoints[:most_popular]['1-20'])['results']
      page_2_results = MovieService.render_request(MovieService.endpoints[:most_popular]['21-40'])['results']
      page_1_results.concat(page_2_results)
    end
  end
end
