require 'rails_helper'

RSpec.describe 'movie details page' do
  before :each do
    # if Rails.application.credentials.movie_db.nil?
    #   @api_key = ''
    #   allow_any_instance_of(Services::RequestEndpoints).to receive(:key).and_return(@api_key)
    # end

    visit movie_path(@movie_id)
  end
  # As an authenticated user,
  # When I visit the movie's detail page,
  # I should see
  #  Button to create a viewing party
  # Details This button should take the authenticated user to the new event page
  # And I should see the following information about the movie:
  #  Movie Title
  #  Vote Average of the movie
  #  Runtime in hours & minutes
  #  Genre(s) associated to movie
  #  Summary description
  #  List the first 10 cast members (characters & actress/actors)
  #  Count of total reviews
  #  Each review's author and information
  it 'displays the movie attributes, cast members, and reviews' do
    # save_and_open_page
    expect(page).to have_content('Movie Details')
    expect(page).to have_css('#title')
    expect(page).to have_css('#runtime')
    expect(page).to have_css('#vote_average')
    expect(page).to have_css('#genres')
    expect(page).to have_css('#overview')
    expect(page).to have_css('#poster')

    expect(page).to have_content('Cast:')
    expect(page).to have_css('#member', count: 10)

    expect(page).to have_content('Reviews')
    expect(page).to have_css('#review', count: 2)
  end

  it 'links to the new viewing party page' do
    click_on 'Create Viewing Party'
    expect(current_path).to eq(new_event_path)
  end

end
