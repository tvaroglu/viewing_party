require 'rails_helper'

RSpec.describe Attendee do
  describe 'relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:event) }
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
        event_time: Time.now,
        runtime: 90
      )
    end

    it "can return the user's email" do
      attendee = Attendee.create!(user: @taylor, event: @event)

      expect(@event.attendees.first.user_email).to eq(@taylor.email)
    end
  end
end
