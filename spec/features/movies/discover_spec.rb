require 'rails_helper'

RSpec.describe 'discover page' do
  before :each do
    visit discover_path
  end
  # As an authenticated user,
  # When I visit the '/discover' path
  # I should see
  #  Button to Discover top 40 movies
  # Details When the user clicks on the top 40 button they should be taken to the movies page.
  #  A text field to enter keyword(s) to search by movie title
  #  A Button to Search by Movie Title
  # Details When the user clicks on the Search button they should be taken to the movies page
  it 'has a link to the most popular movies page' do
    click_on 'Top Rated'
    expect(current_path).to eq(popular_path)
  end
  # As an authenticated user,
    # When I visit the movies page,
    # I should see the 40 results from my search,
    # I should also see the "Find Top Rated Movies" button and the Find Movies form at the top of the page.
  # Details: The results from the search should appear on this page, and there should only be a maximum of 40 results. The following details should be listed for each movie.
  #  Title (As a Link to the Movie Details page)
  #  Vote Average of the movie
  it 'displays up to 40 search results by keyword' do
    expect(page).to_not have_content('Search Results:')

    fill_in :search_criteria, with: @search_criteria
    click_on 'Search'
    expect(page).to have_content('Results:')
    expect(page).to have_css('#result', count: 40)

    within(first('#result')) do
      expect(page).to have_css('#title')
      expect(page).to have_css('#vote_average')
      expect(page).to have_link(@search_criteria.capitalize)
    end
  end

end
