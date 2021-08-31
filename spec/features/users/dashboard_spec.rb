require 'rails_helper'

RSpec.describe 'user dashboard page' do
  before :each do
    @taylor = User.create!(email: 'foo@bar.com', password: 'test')
    @dane = User.create!(email: 'boo@far.com', password: 'nico')
    # @admin = User.create!(email: 'admin@example.com', password: 'guest')
    visit dashboard_path(@admin.id)
  end
  # As an authenticated user,
    # I see a section for friends,
    # In this section, there should be a text field to enter a friend's email and a button to "Add Friend"
  # Scenarios:
    # If I have not added any friends there should be a message. "You currently have no friends".
    # If I have added friends, I should see a list of all my friends.
  # Details: Users should be able to add a friend by their email address, as long as, the friend is a user of our application and exists in our database.
  it 'is on the correct page for the authenticated user' do
    expect(page).to have_content("Welcome, #{@admin.email}!")
    expect(page).to have_content('You Have No Followers')
  end

  describe 'friend search: happy path' do
    it "can search for friends to add that exist in the database that aren't already following the user" do
      expect(page).to have_content('Find Friends:')

      fill_in :email, with: @dane.email
      click_on 'Search'

      expect(current_path).to eq(dashboard_path(@admin.id))
      expect(page).to have_content("#{@dane.email} is now following you!")

      within "#follower-#{@dane.id}" do
        expect(page).to have_content(@dane.email)
      end
    end

    it "can search for friends with a redirect back if that user is already following the user" do
      fill_in :email, with: @dane.email
      click_on 'Search'

      expect(current_path).to eq(dashboard_path(@admin.id))
      expect(page).to have_content("#{@dane.email} is now following you!")

      within "#follower-#{@dane.id}" do
        expect(page).to have_content(@dane.email)
      end

      fill_in :email, with: @dane.email
      click_on 'Search'

      expect(page).to have_content("#{@dane.email} is already following you!")
    end
  end

  describe 'friend search: sad path' do
    it "can redirect back if the friend searched for don't exist in the database" do
      fill_in :email, with: ''
      click_on 'Search'

      expect(current_path).to eq(dashboard_path(@admin.id))
      expect(page).to have_content("Sorry, unable to find an account for \"#{''}\"")
    end
  end

  describe 'viewing parties section' do
    before :each do
      @event_1 = Event.create!(
        user: @taylor,
        movie_title: 'Kangaroo Jack',
        event_date: '2021-08-29'.to_date,
        event_time: '2021-08-29 11:30:35 -0600'.to_time,
        runtime: 90
      )
      # event 1 hosted by Taylor, Taylor and Admin invited
      @attendee_1 = Attendee.create!(user: @taylor, event: @event_1)
      @attendee_2 = Attendee.create!(user: @admin, event: @event_1)

      visit dashboard_path(@admin.id)
    end
    # As an authenticated user,
    # I should see the viewing parties I have been invited to with the following details:
      # Movie Title, which links to the movie show page
      # Date and Time of Event
      # who is hosting the event
      # list of friends invited, with my name in bold
    #
    # I should also see the viewing parties that I have created with the following details:
      # Movie Title, which links to the movie show page
      # Date and Time of Event
      # That I am the host of the party
      # List of friends invited to the viewing party
    it 'displays a section for viewing parties the user is invited to' do
      expect(page).to have_content('My Parties:')
      expect(page).to have_content("Invited To:")
      # save_and_open_page
      within "#event-#{@event_1.id}" do
        expect(page).to have_content('Event Details')
        expect(page).to have_content("Host: #{@event_1.host}")
        expect(page).to have_content("Movie: #{@event_1.movie_title}")
        expect(page).to have_content("Date: #{ApplicationRecord.format_date(@event_1.event_date)}")
        expect(page).to have_content("Time: #{ApplicationRecord.format_time(@event_1.event_time)}")
        expect(page).to have_content('Attendees:')
      end
      within "#attendee-#{@attendee_1.id}" do
        expect(page).to have_content(@attendee_1.user_email)
      end
      within "#attendee-#{@attendee_2.id}" do
        expect(page).to have_content(@attendee_2.user_email)
      end
    end

    it 'displays a section for viewing parties the user is hosting' do
      event_2 = Event.create!(
        user: @dane,
        movie_title: 'The Terminator',
        event_date: '2021-08-28'.to_date,
        event_time: '2021-08-28 21:40:05 -0600'.to_time,
        runtime: 100
      )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@dane)

      # event 2 hosted by Dane, Admin and Dane invited
      attendee_3 = Attendee.create!(user: @admin, event: event_2)
      attendee_4 = Attendee.create!(user: @dane, event: event_2)

      visit dashboard_path(@dane.id)
      # save_and_open_page
      within "#event-#{event_2.id}" do
        expect(page).to have_content('Event Details')
        expect(page).to have_content("Host: #{event_2.host}")
        expect(page).to have_content("Movie: #{event_2.movie_title}")
        expect(page).to have_content("Date: #{ApplicationRecord.format_date(event_2.event_date)}")
        expect(page).to have_content("Time: #{ApplicationRecord.format_time(event_2.event_time)}")
        expect(page).to have_content('Attendees:')
      end
      within "#attendee-#{attendee_3.id}" do
        expect(page).to have_content(attendee_3.user_email)
      end
      within "#attendee-#{attendee_4.id}" do
        expect(page).to have_content(attendee_4.user_email)
      end
    end

    it 'is annoying that SimpleCov makes me re-test a model method I stubbed because this is a feature test' do
      mock_response = "{\"login\":\"tvaroglu\",\"id\":12345678,\"url\":\"https://api.github.com/users/tvaroglu\"}"
      allow(Faraday).to receive(:get).and_return(mock_response)

      expected = MovieFacade.render_request(MovieFacade.endpoints[:most_popular]['1-20'])
      expect(expected['login']).to eq('tvaroglu')
    end

    it 'links to the discover page' do
      # save_and_open_page
      click_on 'Discover Movies'
      expect(current_path).to eq(discover_path)
    end

    # temporarily skipped, assertion will be updated once page is built and route modified accordingly
    xit 'links to the movie show page' do
      # save_and_open_page
      within "#event-#{@event_1.id}" do
        click_on @event_1.movie_title
        expect(current_path).to eq(movie_path(@event_1.id))
      end
    end

  end
end
