module Services
  class RenderRequest
    attr_reader :endpoint

    def initialize(endpoint)
      @endpoint = endpoint
    end

    def parse
      request = MovieService.make_request(@endpoint)
      request.instance_of?(String) ? JSON.parse(request) : JSON.parse(request.body)
    end
  end
end
