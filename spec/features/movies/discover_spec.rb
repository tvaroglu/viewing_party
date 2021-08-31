require 'rails_helper'

RSpec.describe 'discover page' do
  before :each do
    if Rails.application.credentials.movie_db.nil?
      @api_key = ''
      allow_any_instance_of(Services::RequestEndpoints).to receive(:key).and_return(@api_key)
    end

    @search_criteria = 'jack'

    @search_blob_page_1 = File.read('./spec/fixtures/search/search_page_1_response.json')
    @search_blob_page_2 = File.read('./spec/fixtures/search/search_page_2_response.json')
    @search_request_page_1 = stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=1").
      to_return(status: 200, body: @search_blob_page_1)
    @search_request_page_2 = stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{@api_key}&query=#{@search_criteria}&sort_by=popularity.desc&page=2").
      to_return(status: 200, body: @search_blob_page_2)

    allow(MovieFacade).to receive(:make_request).with(MovieFacade.endpoints(@search_criteria)[:search]['1-20']).
      and_return(@search_request_page_1.response.body)
    allow(MovieFacade).to receive(:make_request).with(MovieFacade.endpoints(@search_criteria)[:search]['21-40']).
      and_return(@search_request_page_2.response.body)

    @popular_blob_page_1 = File.read('./spec/fixtures/most_popular/most_popular_page_1_response.json')
    @popular_blob_page_2 = File.read('./spec/fixtures/most_popular/most_popular_page_2_response.json')
    @popular_request_page_1 = stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=1").
      to_return(status: 200, body: @popular_blob_page_1)
    @popular_request_page_2 = stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{@api_key}&sort_by=popularity.desc&page=2").
      to_return(status: 200, body: @popular_blob_page_2)

    allow(MovieFacade).to receive(:make_request).with(MovieFacade.endpoints[:most_popular]['1-20']).
      and_return(@popular_request_page_1.response.body)
    allow(MovieFacade).to receive(:make_request).with(MovieFacade.endpoints[:most_popular]['21-40']).
      and_return(@popular_request_page_2.response.body)

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
    # save_and_open_page
    expect(page).to have_content('Results:')
    expect(page).to have_css('#result', count: 40)

    within(first('#result')) do
      expect(page).to have_css('#title')
      expect(page).to have_css('#vote_average')
    end
  end

  it 'has links to the movie show page' do
    format = JSON.parse(@search_blob_page_1)['results'].first['title'].split(' ')[0].downcase

    fill_in :search_criteria, with: @search_criteria
    click_on 'Search'
    # save_and_open_page
    within(first('#result')) do
      expect(page).to have_current_path(discover_path(format))
    end
  end

end
