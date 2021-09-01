require 'rails_helper'

RSpec.describe 'upcoming movies page' do
  before :each do
    visit upcoming_path
  end

  it 'displays 40 upcoming movies' do
    # save_and_open_page
    expect(page).to have_content('Results:')
    expect(page).to have_css('#result', count: 40)

    within(first('#result')) do
      expect(page).to have_css('#title')
      expect(page).to have_css('#vote_average')
    end
  end

end
