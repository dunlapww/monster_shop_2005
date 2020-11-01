class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def quantity_of_items
    items.count
  end

  def cancel_order
    item_orders.each do |item_order|
      current_inventory = item_order.item.inventory
      item_order.item.update({inventory: current_inventory + item_order.quantity})
      item_order.update({status: "unfulfilled"})
    end
  end

  def fulfilled?
    item_orders.where.not(status: 'fulfilled').empty?
  end
end
