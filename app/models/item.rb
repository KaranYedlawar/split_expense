class Item < ApplicationRecord
  belongs_to :expense
  belongs_to :assigned_to, class_name: "User", optional: true

  validates :name, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
