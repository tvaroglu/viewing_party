require 'rails_helper'

RSpec.describe 'user registration page' do
  before :each do
    visit registration_path
  end
  # When a user visits the '/registration' path they should see a form to register.
  # The form should include:
  #   Email x
  #   Password x
  #   Password Confirmation x
  #   Register Button x
  # Once the user registers they should be logged in and redirected to the dashboard page
  it 'displays a form to enter in user information and redirects to user dashboard' do
    expect(page).to have_content('Email:')
    expect(page).to have_content('Password:')
    expect(page).to have_content('Confirm Password:')

    username = "cat@cats.com"
    password = "cat"

    fill_in 'user[email]', with: username
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password
    # 8/25: Why can't capybara understand this? What is the id: user_username in congress?
    # fill_in 'Email:', with: email
    # fill_in 'Password:', with: password
    # fill_in 'Confirm Password:', with: password
    click_on 'Register User'
    # expect(current_path).to eq("/users/#{@user.id}")
    expect(page).to have_content("Welcome, cat@cats.com!")
  end

  it 'redirects back to registration page if fails model validation' do
    expect(page).to have_content('Email:')
    expect(page).to have_content('Password:')
    expect(page).to have_content('Confirm Password:')

    username = "cat@cats.com"
    password = "cat"

    fill_in 'user[email]', with: username
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: ''

    click_on 'Register User'
    expect(current_path).to eq(registration_path)
    expect(page).to have_content("Oops, couldn't create your account. Please make sure you are using a valid email and password.")
  end
end
