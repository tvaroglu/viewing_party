require 'rails_helper'

RSpec.describe 'user registration page' do
  before :each do
    visit registration_path
  end
  # When a user visits the '/registration' path they should see a form to register.
  # The form should include:
  #   Email t
  #   Password t
  #   Password Confirmation t
  #   Register Button t
  # Once the user registers they should be logged in and redirected to the dashboard page
  it 'displays a form to enter in user information' do
    # save_and_open_page
    expect(page).to have_content('Email:')
    expect(page).to have_content('Password:')
    expect(page).to have_content('Confirm Password:')

    email = 'btbamfan@gmail.com'
    password = 'test'
    save_and_open_page
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password
    # 8/25: Why can't capybara understand this? What is the id: user_username in congress?
    # fill_in 'Email:', with: email
    # fill_in 'Password:', with: password
    # fill_in 'Confirm Password:', with: password

    click_on 'Register User'

  end
end
