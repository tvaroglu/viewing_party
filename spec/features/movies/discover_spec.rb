require 'rails_helper'

RSpec.describe 'discover page' do
  before :each do
    visit discover_path
    if Rails.application.credentials.movie_db.nil?
      @api_key = ''
      allow_any_instance_of(Services::RequestEndpoints).to receive(:key).and_return(@api_key)
    end
    @search_criteria = 'jack'

    @json_blob_page_1 = File.read('./spec/fixtures/search/search_page_1_response.json')
    @json_blob_page_2 = File.read('./spec/fixtures/search/search_page_2_response.json')
    @webmock_request_page_1 = stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=1").
      to_return(status: 200, body: @json_blob_page_1)
    @webmock_request_page_2 = stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=2").
      to_return(status: 200, body: @json_blob_page_2)

    allow(MovieFacade).to receive(:make_request).and_return(@webmock_request_page_1.response.body)
    @page_1_response = MovieFacade.render_request(MovieFacade.endpoints(@search_criteria)[:search]['1-20'])

    allow(MovieFacade).to receive(:make_request).and_return(@webmock_request_page_2.response.body)
    @page_2_response = MovieFacade.render_request(MovieFacade.endpoints(@search_criteria)[:search]['21-40'])
  end
  # As an authenticated user,
  # When I visit the '/discover' path
  # I should see
  #  Button to Discover top 40 movies
  # Details When the user clicks on the top 40 button they should be taken to the movies page.
  #  A text field to enter keyword(s) to search by movie title
  #  A Button to Search by Movie Title
  # Details When the user clicks on the Search button they should be taken to the movies page
  it 'displays a link to the top rated movies page' do
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
    # save_and_open_page
    expect(page).to have_content('Search Results:')
    expect(page).to have_css('#result', count: 40)

    within(first('#result')) do
      expect(page).to have_content('Title:')
      expect(page).to have_content('Vote Average:')
    end
  end

  # temporarily skipped, assertion will be updated once page is built and route modified accordingly
  xit 'links to the movie show page' do
    fill_in :search_criteria, with: @search_criteria
    click_on 'Search'
    # save_and_open_page
    within(first('#result')) do
      click_on @page_2_response['results'].first['title']
      expect(current_path).to eq(movie_path(@admin.id))
    end
  end

end
