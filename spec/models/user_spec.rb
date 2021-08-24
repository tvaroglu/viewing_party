require 'rails_helper'

RSpec.describe User do

  describe 'test test' do
    it 'says hello' do
      expect(User.new.hello).to eq('world')
    end
  end

end
