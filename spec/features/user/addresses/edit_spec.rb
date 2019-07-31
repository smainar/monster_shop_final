require "rails_helper"

RSpec.describe "Edit Address Page", type: :feature do
  describe "As a Registered User" do
    before(:each) do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @user_address_1 = @user.addresses.create!(street: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, nickname: "work")
      @user_address_2 = @user.addresses.create!(street: '987 Spruce St', city: 'Denver', state: 'CO', zip: 80210, nickname: "home")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "I see a link on my profile page that takes me to an edit address form" do
      visit profile_path

      within "#address-#{@user_address_1.id}" do
        expect(page).to have_link("Edit Address")
        click_link("Edit Address")
        expect(current_path).to eq(edit_user_address_path(@user, @user_address_1))
      end
    end

    it "I can edit an address " do
      visit profile_path

      within "#address-#{@user_address_1.id}" do
        click_link("Edit Address")
      end

      type = "work"
      street = "1904 Turing Dr."
      city = "Denver"
      state = "CO"
      zip = 80202

      fill_in "Address Type", with: type
      fill_in "Street Address", with: street
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip

      click_button("Update Address")

      expect(current_path).to eq(profile_path)

      within "#address-#{@user_address_1.id}" do
        expect(@user_address_1.reload.nickname).to have_content(type)
        expect(@user_address_1.reload.street).to have_content(street)
        expect(@user_address_1.reload.city).to have_content(city)
        expect(@user_address_1.reload.state).to have_content(state)
        expect(@user_address_1.reload.zip).to have_content(zip)
      end
    end

    it "I cannot edit an address without a street address" do
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

      expect(page).to have_content("Street can't be blank")
    end

    it "I cannot edit an address without a city" do
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

      expect(page).to have_content("City can't be blank")
    end

    it "I cannot edit an address without a state" do
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

      expect(page).to have_content("State can't be blank")
    end

    it "I cannot edit an address without a zip" do
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

      expect(page).to have_content("Zip can't be blank")
    end
  end
end
