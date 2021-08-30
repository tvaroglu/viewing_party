module Services
  class Movie
    def initialize(attributes)
      @id = attributes['id']
      @title = attributes['title']
      @vote_average = attributes['vote_average']
      @attributes_hash = Hash.new('')
    end

    def hash
      @attributes_hash[:id] = @id
      @attributes_hash[:title] = @title
      @attributes_hash[:vote_average] = @vote_average
      return @attributes_hash
    end
  end
end
