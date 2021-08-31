require 'rails_helper'

RSpec.describe 'movie details page' do
  before :each do
    if Rails.application.credentials.movie_db.nil?
      @api_key = ''
      allow_any_instance_of(Services::RequestEndpoints).to receive(:key).and_return(@api_key)
    end

    @movie_id = 75780

    @details_blob = File.read('./spec/fixtures/movie_details.json')
    @details_request = stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}?api_key=#{@api_key}").
      to_return(status: 200, body: @details_blob)
    allow(MovieFacade).to receive(:render_request).with(MovieFacade.endpoints('', @movie_id)[:details][:movie]).
      and_return(JSON.parse(@details_request.response.body))

    @reviews_blob = File.read('./spec/fixtures/reviews.json')
    @reviews_request = stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}/reviews?api_key=#{@api_key}&language=en-US&page=1").
      to_return(status: 200, body: @reviews_blob)
    allow(MovieFacade).to receive(:render_request).with(MovieFacade.endpoints('', @movie_id)[:details][:reviews]).
      and_return(JSON.parse(@reviews_request.response.body))

    @cast_blob = File.read('./spec/fixtures/cast.json')
    @cast_request = stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}/credits?api_key=#{@api_key}&language=en-US").
      to_return(status: 200, body: @cast_blob)
    allow(MovieFacade).to receive(:render_request).with(MovieFacade.endpoints('', @movie_id)[:details][:cast]).
      and_return(JSON.parse(@cast_request.response.body))

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

    expect(page).to have_content('Cast:')
    expect(page).to have_css('#member', count: 10)

    expect(page).to have_content('Reviews')
    expect(page).to have_css('#review', count: 2)
  end

  # temporarily skipped, assertion will be updated once page is built and route modified accordingly
  xit 'links to the new viewing party page' do
    click_on 'Create Viewing Party'
    expect(current_path).to eq(new_event_path)
  end

end
