module Services
  class Review
    def initialize(attributes)
      @id = attributes['id']
      @author = attributes['author']
      @content = attributes['content']
      @attributes_hash = Hash.new('')
    end

    def hash
      @attributes_hash[:id] = @id
      @attributes_hash[:author] = @author
      @attributes_hash[:content] = @content
      @attributes_hash
    end
  end
end
