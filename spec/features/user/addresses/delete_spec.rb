require "rails_helper"

RSpec.describe "Destroy an Address", type: :feature do
  describe "As a Registered User" do
    before(:each) do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )

      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')

      @user_address_1 = @user.addresses.create!(street: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, nickname: "work")
      @user_address_2 = @user.addresses.create!(street: '987 Spruce St', city: 'Denver', state: 'CO', zip: 80210, nickname: "home")
      @user_address_3 = @user.addresses.create!(street: '456 Maple Rd', city: 'Vail', state: 'CO', zip: 81657, nickname: "work")

      # Shipped
      @order_1 = @user.orders.create!(status: "shipped", address: @user_address_1)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_item_2 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)

      # Pending
      @order_2 = @user.orders.create!(status: "pending", address: @user_address_1)
      @order_item_3 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 10)

      # Packaged
      @order_3 = @user.orders.create!(status: "packaged", address: @user_address_2)
      @order_item_4 = @order_3.order_items.create!(item: @hippo, price: @hippo.price, quantity: 6)
      @order_item_5 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 7)

      # Cancelled
      @order_4 = @user.orders.create!(status: "cancelled", address: @user_address_3)
      @order_item_6 = @order_4.order_items.create!(item: @hippo, price: @hippo.price, quantity: 27)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "I can delete an address from my profile page" do
      visit profile_path

      within "#address-#{@user_address_1.id}" do
        expect(page).to have_content(@user_address_1.street)
        expect(page).to have_content(@user_address_1.zip)
      end

      within "#address-#{@user_address_2.id}" do
        expect(page).to have_content(@user_address_2.street)
        expect(page).to have_content(@user_address_2.zip)
        expect(page).to have_link("Delete Address")
      end

      within "#address-#{@user_address_3.id}" do
        expect(page).to have_content(@user_address_3.street)
        expect(page).to have_content(@user_address_3.zip)
        expect(page).to have_link("Delete Address")
        
        click_link("Delete Address")
      end

      expect(page).to have_content("Address was deleted!")
      expect(current_path).to eq(profile_path)

      @user.reload
      visit profile_path

      expect(page).to_not have_css("section#address-#{@user_address_3.id}")
      expect(page).to_not have_content(@user_address_3.street)
    end

    it "I cannot delete an address if it's been used in a 'shipped' order" do
      visit profile_path

      within "#address-#{@user_address_1.id}" do
        expect(page).to_not have_link("Delete Address")
        expect(page).to_not have_link("Edit Address")
      end

      within "#address-#{@user_address_2.id}" do
        expect(page).to have_link("Delete Address")
        expect(page).to have_link("Edit Address")
      end

      within "#address-#{@user_address_3.id}" do
        expect(page).to have_link("Delete Address")
        expect(page).to have_link("Edit Address")
      end
    end
  end
end
