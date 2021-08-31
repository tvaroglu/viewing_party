require 'rails_helper'

RSpec.describe 'event index page' do
  before :each do
    @event1 = Event.create!(movie_title: 'Suspiria', event_date: '2021-08-30'.to_date, event_time: '2021-08-30 18:14:42 -0600'.to_time, runtime: 125, user: @admin)
    @taylor = User.create!(email: 'foo@bar.com', password: 'test')
    @dane = User.create!(email: 'boo@far.com', password: 'nico')
    @admin.followers << [@dane, @taylor]
    visit new_event_path
  end
  # As an authenticated user,
  # When I visit the new viewing party page,
  # I should see the name of the movie title rendered above a form with the following fields: t
  #   Duration of Party with a default value of movie runtime in minutes; a viewing party should NOT be created if set to a value less than the duration of the movie
  #   When: field to select date X
  #   Start Time: field to select time t
  #   Checkboxes next to each friend (if user has friends) t
  #   Button to create a party t
  # Whenever a user creates an event, should designate the creator as an attendee
  # @attendee_1 = Attendee.create!(user: @taylor, event: @event_1)
  # @attendee_2 = Attendee.create!(user: @admin, event: @event_1)
  it 'can display the movie title with all form information' do
    save_and_open_page
    expect(page).to have_content("Create New Viewing Party")
    expect(page).to have_content('Event Date:')
    expect(page).to have_content('Start Time:')
    # expect(page).to have_content('Friends:')
    expect(page).to have_button('Create Event')

  end
end
