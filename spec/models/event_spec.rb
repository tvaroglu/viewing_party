require 'rails_helper'

RSpec.describe Event do
  describe 'validations' do
    it { should validate_presence_of(:movie_title) }
    it { should validate_presence_of(:movie_id) }
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

      allow(Date).to receive(:today).and_return('2021-08-28'.to_date)
      allow(Time).to receive(:now).and_return('2021-08-28 17:17:00 -0600'.to_time)
      @event = Event.create!(
        user: @taylor,
        movie_title: 'Kangaroo Jack',
        movie_id: 3,
        event_date: Date.today,
        event_time: Time.now,
        runtime: 90
      )
    end

    it 'can return the host email for the event' do
      expect(@event.host).to eq(@taylor.email)
    end

    it 'can return events a user is invited to' do
      Attendee.create!(user: @taylor, event: @event)
      Attendee.create!(user: @dane, event: @event)

      expect(User.events_invited_to(@dane.id)).to eq([@event])
    end

    it 'can return the formatted date and time for an event' do
      expect(ApplicationRecord.format_date(@event.event_date)).to eq('August 28, 2021')
      expect(ApplicationRecord.format_time(@event.event_time)).to eq('11:17 PM')

      event_params = {
        'event_time(1i)'=>'2021',
        'event_time(2i)'=>'9',
        'event_time(3i)'=>'1',
        'event_time(4i)'=>'01',
        'event_time(5i)'=>'00'
      }
      expect(ApplicationRecord.parse_event_time(event_params)).to eq('2021-09-01 00:00:00.000000000 -0600')
    end
  end
end
