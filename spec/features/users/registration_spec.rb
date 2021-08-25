require 'rails_helper'

RSpec.describe 'user registration page' do
  before :each do
    visit new_user_path
  end
  # When a user visits the '/registration' path they should see a form to register.
  # The form should include:
  #   Email
  #   Password
  #   Password Confirmation
  #   Register Button
  # Once the user registers they should be logged in and redirected to the dashboard page
  it 'displays a form to enter in user information' do

    expect(page).to have_content()
  end

end
