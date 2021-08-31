module Services
  class CastMember
    def initialize(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @character = attributes['character']
      @attributes_hash = Hash.new('')
    end

    def hash
      @attributes_hash[:id] = @id
      @attributes_hash[:name] = @name
      @attributes_hash[:character] = @character
      @attributes_hash
    end
  end
end
