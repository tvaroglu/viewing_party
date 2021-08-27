require 'rails_helper'

RSpec.describe "Logging In" do
  before :each do
    @user = User.create!(
      email: 'foo@bar.com',
      password: 'guest')
  end
  # As a registered user
    # When I visit '/' and I click on a link that says "Log In"
    # Then I should see a login form
    # When I enter my email and password and submit the form
    # I am redirected to my dashboard page
    # and I see a welcome message with my username
    # and I should no longer see the link that says "Log In"
    # and I should no longer see the link that says "New User Registration"
    # and I should see a link that says "Log Out"
  it 'cannot log a user in with invalid credentials' do
    visit login_path

    fill_in :email, with: @user.email
    fill_in :password, with: ''

    click_on 'Log In'
    expect(current_path).to eq(login_path)

    expect(page).to have_content('Invalid credentials, please try again.')
  end

  it 'can log a user in (and out) if valid credentials are provided' do
    visit root_path
    click_on 'Log In'
    expect(current_path).to eq(login_path)

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    fill_in :password_confirmation, with: @user.password

    click_on 'Log In'
    expect(current_path).to eq(dashboard_path(@user.id))
    expect(page).to have_content("Welcome, #{@user.email}!")

    visit root_path
    expect(page).to_not have_link('Log In')
    expect(page).to_not have_link('New User Registration')

    click_on 'Log Out'
    expect(current_path).to eq(root_path)
    expect(page).to have_content('You are now logged out, please come back soon!')
  end

end
