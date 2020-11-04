class Item <ApplicationRecord
  before_save :fill_in_blank_image

  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than_or_equal_to: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.most_popular
    joins(:item_orders)
    .select("sum(quantity) as total_quantity, name")
    .group(:name)
    .order("total_quantity DESC")
    .limit(5)
  end

  def self.least_popular
    joins(:item_orders)
    .select("sum(quantity) as total_quantity, name")
    .group(:name)
    .order("total_quantity")
    .limit(5)
  end

  def fill_in_blank_image
    self.image = 'https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png' if image == ""
  end

  def ok_to_fulfill?
    self.status != "fulfilled"  && self.inventory >= self.quantity
  end

end
