require 'rails_helper'

RSpec.describe 'welcome index page' do
  before :each do
    visit root_path
  end
  # Welcome Page
  # When a user visits the root path they should be on the welcome page which includes:
    # Welcome message X
    # Brief description of the application X
    # Button to Log in X
    # Link to Registration X
  it 'can display information about the application' do
    expect(page).to have_content('Welcome to Viewing Party!')
  end

  it 'can display a button to log in and a link to new user registration' do
    expect(page).to have_link('Log In')
    expect(page).to have_link('Create an Account')
  end

  it 'links the users to log-in and register' do
    click_on 'Log In'
    expect(current_path).to eq(login_path)

    visit root_path
    click_on 'Create an Account'
    expect(current_path).to eq(registration_path)
  end
end
