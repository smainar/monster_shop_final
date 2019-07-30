require "rails_helper"

RSpec.describe Address, type: :model do
  describe "validations" do
    it {should validate_presence_of :street}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :nickname}
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe "instance methods" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

      @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
      @user_address_1 = @user.addresses.create!(street: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, nickname: "work")
      @user_address_2 = @user.addresses.create!(street: '987 Spruce St', city: 'Denver', state: 'CO', zip: 80210, nickname: "home")

      @order_1 = @user.orders.create!(status: "packaged", address: @user_address_1)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 5, fulfilled: true)

      @order_2 = @user.orders.create!(status: "pending", address: @user_address_2)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)

      @order_3 = @user.orders.create!(status: "shipped", address: @user_address_2)
      @order_item_4 = @order_3.order_items.create!(item: @ogre, price: @ogre.price, quantity: 1, fulfilled: true)

      @order_4 = @user.orders.create!(status: "cancelled", address: @user_address_2)
      @order_item_5 = @order_4.order_items.create!(item: @giant, price: @giant.price, quantity: 1, fulfilled: true)
    end

    it "#shipped_orders" do
      expect(@user_address_1.shipped_orders).to eq([])
      expect(@user_address_2.shipped_orders).to eq([@order_3])
    end
  end
end
