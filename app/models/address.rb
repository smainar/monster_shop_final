class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy

  validates_presence_of :street,
                        :city,
                        :state,
                        :zip,
                        :nickname

  def shipped_orders
    self.orders.where(status: "shipped")
  end
end
