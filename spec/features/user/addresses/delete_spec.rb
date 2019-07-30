require "rails_helper"

RSpec.describe "Destroy an Address", type: :feature do
  describe "As a Registered User" do
    before(:each) do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')

      @user_address_1 = @user.addresses.create!(street: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, nickname: "work")
      @user_address_2 = @user.addresses.create!(street: '987 Spruce St', city: 'Denver', state: 'CO', zip: 80210, nickname: "home")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "I can delete an address from my profile page" do
      visit profile_path

      within "#address-#{@user_address_1.id}" do
        expect(page).to have_link("Delete Address")
        click_link("Delete Address")
      end
      expect(page).to have_content("Address was deleted!")
      expect(current_path).to eq(profile_path)

      @user.reload
      visit profile_path

      expect(page).to have_css("section#address-#{@user_address_2.id}")
      expect(page).to have_content(@user_address_2.street)
      expect(page).to have_content(@user_address_2.zip)

      expect(page).to_not have_content(@user_address_1.street)
      expect(page).to_not have_css("section#address-#{@user_address_1.id}")

      visit profile_path

      within "#address-#{@user_address_2.id}" do
        expect(page).to have_link("Delete Address")
        click_link("Delete Address")
      end
      expect(current_path).to eq(profile_path)
    end
  end
end
