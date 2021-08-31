require 'rails_helper'

RSpec.describe 'movie details page' do
  before :each do
    if Rails.application.credentials.movie_db.nil?
      @api_key = ''
      allow_any_instance_of(Services::RequestEndpoints).to receive(:key).and_return(@api_key)
    end

    @movie_id = 75780
  end
  # As an authenticated user,
  # When I visit the '/discover' path
  # I should see
  #  Button to Discover top 40 movies
  # Details When the user clicks on the top 40 button they should be taken to the movies page.
  #  A text field to enter keyword(s) to search by movie title
  #  A Button to Search by Movie Title
  # Details When the user clicks on the Search button they should be taken to the movies page
  it 'displays the movie attributes' do
    json_blob = File.read('./spec/fixtures/movie_details.json')
    webmock_request = stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}?api_key=#{@api_key}").
      to_return(status: 200, body: json_blob)
    allow(MovieFacade).to receive(:make_request).and_return(webmock_request.response.body)

    visit movie_path(@movie_id)
    # save_and_open_page
    expect(page).to have_content('Movie Details')
    expect(page).to have_css('#title')
    expect(page).to have_css('#runtime')
    expect(page).to have_css('#vote_average')
    expect(page).to have_css('#genres')
    expect(page).to have_css('#overview')
  end

end
