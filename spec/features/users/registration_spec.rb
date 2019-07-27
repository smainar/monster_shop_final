require 'rails_helper'

RSpec.describe 'User Registration' do
  describe 'As a Visitor' do
    it 'I see a link to register as a user' do
      visit root_path

      click_link 'Register'

      expect(current_path).to eq(registration_path)
    end

    it 'I can register as a user' do
      visit registration_path

      fill_in "user[name]", with: "Megan"
      fill_in "user[email]", with: "megan@example.com"
      fill_in "user[password]", with: "securepassword"
      fill_in "user[password_confirmation]", with: "securepassword"
      fill_in "user[addresses_attributes][0][street]", with: "123 Main St"
      fill_in "user[addresses_attributes][0][city]", with: "Denver"
      fill_in "user[addresses_attributes][0][state]", with: "CO"
      fill_in "user[addresses_attributes][0][zip]", with: "80218"
      fill_in "user[addresses_attributes][0][nickname]", with: "home"

      click_button 'Register'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Welcome, Megan!')
    end

    describe 'I can not register as a user if' do
      it 'I do not complete the registration form' do
        visit registration_path

        fill_in 'Name', with: 'Megan'
        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("street: [\"can't be blank\"]")
        expect(page).to have_content("city: [\"can't be blank\"]")
        expect(page).to have_content("state: [\"can't be blank\"]")
        expect(page).to have_content("zip: [\"can't be blank\"]")
        expect(page).to have_content("email: [\"can't be blank\"]")
        expect(page).to have_content("password: [\"can't be blank\"]")
      end

      it 'I use a non-unique email' do
        user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
        address = user.addresses.create!(street: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, nickname: "home")

        visit registration_path

        fill_in "user[name]", with: user.name
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        fill_in "user[password_confirmation]", with: user.password
        fill_in "user[addresses_attributes][0][street]", with: address.street
        fill_in "user[addresses_attributes][0][city]", with: address.city
        fill_in "user[addresses_attributes][0][state]", with: address.state
        fill_in "user[addresses_attributes][0][zip]", with: address.zip
        fill_in "user[addresses_attributes][0][nickname]", with: address.nickname
        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("email: [\"has already been taken\"]")
      end
    end
  end
end
