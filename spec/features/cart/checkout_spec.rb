require 'rails_helper'

RSpec.describe "Cart checkout functionality" do
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

      # Pending
      @order_1 = @user.orders.create!(status: "pending", address: @user_address_1)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_item_2 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)

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

    it "When I check out, I can select an address to ship my order" do
      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit cart_path

      within "#shipping-address" do
        expect(page).to have_content("Ship to:")
        select(@user_address_1.street)
        click_button 'Check Out'
      end

      order = Order.last
      expect(page).to have_content("Order created successfully!")

      expect(current_path).to eq(profile_orders_path)
      expect(page).to have_content("Order No.: #{order.id}")
      expect(page).to have_link("Order No.: #{order.id}")
      expect(page).to have_content(order.created_at)
      expect(page).to have_content(order.updated_at)
      expect(page).to have_content("Status: pending")
      expect(page).to have_content("Cart: 0")
    end

    it "If I delete all of my addresses, then I cannot check out and see an error telling me that I need to add an address first" do
      visit profile_path

      within "#address-#{@user_address_1.id}" do
        click_link("Delete Address")
      end

      @user.reload
      visit profile_path

      within "#address-#{@user_address_2.id}" do
        click_link("Delete Address")
      end

      @user.reload
      visit profile_path

      within "#address-#{@user_address_3.id}" do
        click_link("Delete Address")
      end

      @user.reload
      visit profile_path

      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit cart_path

      expect(page).to_not have_button("Check Out")
      expect(page).to have_content("To check out, you must add a shipping address.")

      expect(page).to have_link("add a shipping address")
      click_link("add a shipping address")
      expect(current_path).to eq("/users/#{@user.id}/addresses/new")
      expect(page).to have_field("Address Type")
      expect(page).to have_field("Street Address")
    end
  end
end
