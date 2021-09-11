module Services
  class RenderRequest
    attr_reader :endpoint

    def initialize(endpoint)
      @endpoint = endpoint
    end

    def conn
      request = Faraday.new(url: @endpoint) do |faraday|
        faraday.headers['Authorization'] = ENV['bearer']
      end.get(@endpoint)
    end

    def parse
      conn.instance_of?(String) ? JSON.parse(conn) : JSON.parse(conn.body)
    end
  end
end
