require 'rails_helper'

RSpec.describe 'user dashboard page' do
  before :each do
    @taylor = User.create!(email: 'foo@bar.com', password: 'test')
    @dane = User.create!(email: 'boo@far.com', password: 'nico')
    @admin = User.create!(email: 'admin@example.com', password: 'guest')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

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

end
