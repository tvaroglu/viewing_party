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
    it { should have_many(:attendees) }
    it { should have_many(:users).through(:attendees) }
  end

  describe 'methods' do
    before :each do
      @taylor = User.create!(email: 'foo@bar.com', password: 'test')
      @dane = User.create!(email: 'boo@far.com', password: 'nico')
      @admin = User.create!(email: 'admin@example.com', password: 'guest')
      @event = Event.create!(
        user: @taylor,
        movie_title: 'Kangaroo Jack',
        event_date: Date.today,
        event_time: Time.now + 120,
        runtime: 90
      )
    end

    it 'can return the host email for the event' do
      expect(@event.host).to eq(@taylor.email)
    end

    it 'can return the formatted date and time for the event' do
      allow(Date).to receive(:today).and_return('2021-08-28'.to_date)
      allow(Time).to receive(:now).and_return('2021-08-28 16:25:18 -0600'.to_time)

      expect(ApplicationRecord.format_date(Date.today)).to eq('Saturday, August 28, 2021')
      expect(ApplicationRecord.format_time(Time.now)).to eq('04:25 PM')
    end
  end
end
