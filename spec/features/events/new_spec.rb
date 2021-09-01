require 'rails_helper'

RSpec.describe 'event index page' do
  before :each do
    @taylor = User.create!(email: 'foo@bar.com', password: 'test')
    @event1 = Event.create!(
      movie_title: 'Suspiria',
      movie_id: 666,
      event_date: '2021-08-30'.to_date,
      event_time: '2021-08-30 08:00:00 -0600'.to_time,
      runtime: 125,
      user: @taylor)

    @dane = User.create!(email: 'boo@far.com', password: 'nico')
    @admin.followers << [@dane, @taylor]

    visit new_event_path
  end
  # As an authenticated user,
  # When I visit the new viewing party page,
  # I should see the name of the movie title rendered above a form with the following fields: t
  #   Duration of Party with a default value of movie runtime in minutes; a viewing party should NOT be created if set to a value less than the duration of the movie
  #   When: field to select date X
  #   Start Time: field to select time X
  #   Checkboxes next to each friend (if user has friends) X
  #   Button to create a party X
  # Whenever a user creates an event, should designate the creator as an attendee
  # @attendee_1 = Attendee.create!(user: @taylor, event: @event_1)
  # @attendee_2 = Attendee.create!(user: @admin, event: @event_1)
  it 'can display the movie title with all form information' do
    expect(page).to have_content('Create New Viewing Party')
    expect(page).to have_content('Event Date:')
    expect(page).to have_content('Start Time:')
    expect(page).to have_content('Your Current Followers:')
    expect(page).to have_button('Create Event')
  end

  #Happy Path
  it 'can enter in event information and create a new event' do
    fill_in :movie_title, with: @event1.movie_title
    find_field(id: :movie_id, type: :hidden).set(1)
    fill_in :event_date, with: '2021/08/30'
    fill_in :runtime, with: @event1.runtime
    select '02 PM', :from => "event[event_time(4i)]"
    select '00', :from => "event[event_time(5i)]"

    within "#follower-#{@admin.followers.first.id}" do
      check 'invited[]'
    end
    within "#follower-#{@admin.followers.last.id}" do
      check 'invited[]'
    end

    click_on 'Create Event'

    expect(current_path).to eq(dashboard_path(@admin.id))
    expect(page).to have_content("Host: #{@admin.email}")
    expect(page).to have_content("Date: #{ApplicationRecord.format_date(@event1.event_date)}")
    expect(page).to have_content("Time: #{ApplicationRecord.format_time(@event1.event_time)}")

    within(first('#attendees')) do
      expect(page).to have_content(@taylor.email)
      expect(page).to have_content(@dane.email)
      expect(page).to have_content(@admin.email)
    end
  end

  #Sad Path
  it 'can redirect back to new page if improper/no information provided and display error message' do
    fill_in :movie_title, with: @event1.movie_title
    fill_in :event_date, with: '2021/08/30'
    fill_in :runtime, with: @event1.runtime
    click_on 'Create Event'

    expect(current_path).to eq(new_event_path)
    expect(page).to have_content('Error: You must invite followers to your party,')
    expect(page).to have_field(:movie_title, with: @event1.movie_title)
    expect(page).to have_field(:runtime, with: @event1.runtime)
  end
end
