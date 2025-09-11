class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :expenses, dependent: :destroy
  has_many :assigned_items, class_name: "Item", foreign_key: "assigned_to_id"
  has_many :expense_users
  has_many :shared_expenses, through: :expense_users, source: :expense
  
end
