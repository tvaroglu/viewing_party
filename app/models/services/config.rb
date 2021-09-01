module Services
  class Config
    def initialize
      @response = MovieFacade.render_request(MovieFacade.endpoints[:config])
      @secure_base_url = @response['images']['secure_base_url']
      @poster_sizes = @response['images']['poster_sizes']
      @attributes_hash = Hash.new('')
    end

    def hash
      @attributes_hash[:secure_base_url] = @secure_base_url
      @attributes_hash[:poster_size] = @poster_sizes.select { |size| size == 'w500' }.first
      @attributes_hash
    end
  end
end
