class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  def self.status_sort
    self.order(Arel.sql("CASE
                  WHEN status='packaged' THEN '1'
                  WHEN status='pending' THEN '2'
                  WHEN status='shipped' THEN '3'
                  WHEN status='cancelled' THEN '4'
                END"))
  end

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def quantity_of_items
    items.count
  end

  def package
    update(status: "packaged") if item_orders.where.not(status: "fulfilled").empty?
  end

  def merchant_items_qty(merchant_id)
    items.where("items.merchant_id=?", merchant_id).sum(:quantity)
  end

  def merchant_items_value(merchant_id)
    items.where("items.merchant_id=?", merchant_id).sum("item_orders.quantity * item_orders.price")
  end

  def can_be_cancelled?
    status == "pending" || status == "packaged"
  end
end
