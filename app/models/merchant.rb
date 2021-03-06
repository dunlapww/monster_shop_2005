class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items

  has_many :users
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


  def self.not_disabled
    where.not(active?: false)
  end

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def pending_orders
    orders.where(status: "pending").distinct
  end

  def toggle_active_status
    self.toggle!(:active?)
    switch_items_active_status
  end


  def switch_items_active_status
    if self.active?
      items.update_all(active?: true)
    else
      items.update_all(active?: false)
    end
  end
end
