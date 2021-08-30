require 'rails_helper'

RSpec.describe 'user registration page' do
  before :each do
    visit registration_path
    @email = 'cat@cats.com'
    @password = 'cat'
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

    fill_in :email, with: @email
    fill_in :password, with: @password
    fill_in :password_confirmation, with: @password

    click_on 'Register User'

    expect(current_path.to_s.split('.')[0]).to eq('/dashboard')
    expect(page).to have_content("New account successfully created for: #{@email}!")
  end

  it 'redirects back to registration page upon failed model validation' do
    expect(page).to have_content('Email:')
    expect(page).to have_content('Password:')
    expect(page).to have_content('Confirm Password:')

    fill_in :email, with: @email
    fill_in :password, with: @password
    fill_in :password_confirmation, with: ''

    click_on 'Register User'

    expect(current_path).to eq(registration_path)
    expect(page).to have_content('Invalid credentials, please try again.')
  end
end
