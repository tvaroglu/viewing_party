require 'rails_helper'

RSpec.describe 'most popular movies page' do
  before :each do
    # if Rails.application.credentials.movie_db.nil?
    #   @api_key = ''
    #   allow_any_instance_of(Services::RequestEndpoints).to receive(:key).and_return(@api_key)
    # end

    visit popular_path
  end
  # As an authenticated user,
  # When I visit the '/discover' path
  # I should see
  #  Button to Discover top 40 movies
  # Details When the user clicks on the top 40 button they should be taken to the movies page.
  #  A text field to enter keyword(s) to search by movie title
  #  A Button to Search by Movie Title
  # Details When the user clicks on the Search button they should be taken to the movies page
  it 'displays the 40 most popular movies' do
    # save_and_open_page
    expect(page).to have_content('Results:')
    expect(page).to have_css('#result', count: 40)

    within(first('#result')) do
      expect(page).to have_css('#title')
      expect(page).to have_css('#vote_average')
    end
  end

end
