require 'rails_helper'

describe 'As a user' do
  before :each do
    User.create(email: 'test@gmail.com', password: 'test', first_name: 'Alex', last_name: 'Rivero')

    visit  '/'
    fill_in :email,	with: "test@gmail.com"
    fill_in :password,	with: "test"
    click_button 'Sign In'
  end

  it "When i click on Find Top Movies in discover I am taken to the top 40 movies link" do
    visit '/discover'

    click_button 'Find Top Rated Movies'

    expect(current_path).to eq('/movies/top_rated')
  end

  it "There are 40 top rated movies on the page" do
    visit '/movies/top_rated'

    expect(page).to have_css('.movie-column', count: 40)
    expect(page).to have_css('.vote-column', count: 40)
  end
end
