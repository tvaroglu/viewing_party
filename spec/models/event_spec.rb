require 'rails_helper'

RSpec.describe Event do
  describe 'validations' do
    it { should validate_presence_of(:movie_title) }
    it { should validate_presence_of(:event_date) }
    it { should validate_presence_of(:event_time) }
    it { should validate_presence_of(:runtime) }
  end

  describe 'relationships' do
    it { should belong_to(:user) }
  end
end
