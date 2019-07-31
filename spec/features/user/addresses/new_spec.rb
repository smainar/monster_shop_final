require "rails_helper"

RSpec.describe "New Address Creation", type: :feature do
  describe "As a Registered User" do
    before(:each) do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @user_address = @user.addresses.create!(street: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, nickname: "home")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "I see a link on my profile page that takes me to a new address form" do
      visit profile_path

      expect(page).to have_link("Add Address")
      click_link("Add Address")
      expect(current_path).to eq("/users/#{@user.id}/addresses/new")
    end

    it "I can create a new address from the new address page" do
      visit profile_path

      click_link("Add Address")

      type = "work"
      street = "321 Logan St."
      city = "Englewood"
      state = "CO"
      zip = 80113

      fill_in "Address Type", with: type
      fill_in "Street Address", with: street
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip

      click_on "Create Address"

      new_address = Address.last

      expect(current_path).to eq(profile_path)

      within "#address-#{new_address.id}" do
        expect(page).to have_content(type)
        expect(page).to have_content(street)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip)
      end
    end

    it "I cannot create a new address without a street address" do
      visit profile_path

      click_link("Add Address")

      type = "work"
      street = "321 Logan St."
      city = "Englewood"
      state = "CO"
      zip = 80113

      fill_in "Address Type", with: type
      # fill_in "Street Address", with: street
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip

      click_on "Create Address"

      new_address = Address.last

      expect(page).to have_content("Street can't be blank")
    end

    it "I cannot create a new address without a city" do
      visit profile_path

      click_link("Add Address")

      type = "work"
      street = "321 Logan St."
      city = "Englewood"
      state = "CO"
      zip = 80113

      fill_in "Address Type", with: type
      fill_in "Street Address", with: street
      # fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip

      click_on "Create Address"

      new_address = Address.last

      expect(page).to have_content("City can't be blank")
    end

    it "I cannot create a new address without a state" do
      visit profile_path

      click_link("Add Address")

      type = "work"
      street = "321 Logan St."
      city = "Englewood"
      state = "CO"
      zip = 80113

      fill_in "Address Type", with: type
      fill_in "Street Address", with: street
      fill_in "City", with: city
      # fill_in "State", with: state
      fill_in "Zip", with: zip

      click_on "Create Address"

      new_address = Address.last

      expect(page).to have_content("State can't be blank")
    end

    it "I cannot create a new address without a state" do
      visit profile_path

      click_link("Add Address")

      type = "work"
      street = "321 Logan St."
      city = "Englewood"
      state = "CO"
      zip = 80113

      fill_in "Address Type", with: type
      fill_in "Street Address", with: street
      fill_in "City", with: city
      fill_in "State", with: state
      # fill_in "Zip", with: zip

      click_on "Create Address"

      new_address = Address.last

      expect(page).to have_content("Zip can't be blank")
    end
  end
end
