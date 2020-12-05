require 'rails_helper'

describe 'As a user' do
  before :each do
    User.create(email: 'test@gmail.com', password: 'test', first_name: 'Alex', last_name: 'Rivero')

    visit  '/'
    fill_in :email,	with: "test@gmail.com"
    fill_in :password,	with: "test"
    click_button 'Sign In'

    @current_user = User.last
    @movie = Movie.create!(title: 'Avengers', api_id: 550)
    @party = Party.create!(user_id: @current_user.id, movie_id: @movie.id, date: '1/12/2020', time: '2:00 PM', duration: 220)
  end

  it "I am in the dashboard link" do
    expect(current_path).to eq('/dashboard')
  end

  it "Has clickable button to Discover movies" do
    expect(page).to have_button('Discover Movies')

    click_button 'Discover Movies'

    expect(current_path).to eq('/discover')
  end

  it "Page has a textbox and a button to add friend" do
    within id="#Friends" do
      expect(page).to have_css('input[type="text"]')
      expect(page).to have_button('Add Friend')
    end
  end

  it "User currently has no friends" do
    within id="#Friends" do
      expect(page).to have_content('You currently have no friends')
    end
  end

  it "Section show current parties and their info for user if any" do
    Guest.create(party_id: @party.id, user_id: @current_user.id, attending: true)

    visit '/dashboard'

    within id="#party-#{@party.id}" do
      expect(page).to have_content('Avengers')
      expect(page).to have_content('December 1, 2020')
      expect(page).to have_content('2:00 PM')
      expect(page).to have_content('Hosting')
    end
  end

  it "Party has invited when the user is a guest and not the host" do
    click_link 'Logout'
    User.create(email: 'test@test.com', password: 'testing', first_name: 'James', last_name: 'Morgan')

    visit  '/'
    fill_in :email,	with: "test@test.com"
    fill_in :password,	with: "testing"
    click_button 'Sign In'

    current_user = User.last
    Guest.create(party_id: @party.id, user_id: current_user.id, attending: true)

    visit '/dashboard'

    within id="#party-#{@party.id}" do
      expect(page).to have_content('Avengers')
      expect(page).to have_content('December 1, 2020')
      expect(page).to have_content('2:00 PM')
      expect(page).to have_content('Invited')
    end
  end
end
