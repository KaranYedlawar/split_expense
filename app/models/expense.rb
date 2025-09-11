class Expense < ApplicationRecord
    belongs_to :user
    has_many :items, dependent: :destroy
    has_many :expense_users, dependent: :destroy
    has_many :shared_users, through: :expense_users, source: :user

    validates :description, :total_amount, presence: true
    validates :tax, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def split_expense!
    # Clear any previous splits
    expense_users.destroy_all

    # Determine all involved users
    assigned_user_ids = items.where.not(assigned_to_id: nil).pluck(:assigned_to_id)
    shared_users = items.where(assigned_to_id: nil).present? ? User.all.pluck(:id) : []
    all_users_ids = (assigned_user_ids + shared_users).uniq

    # Initialize hash to store how much each user owes
    user_shares = Hash.new(0)

    # Add amounts for items assigned to specific users
    items.where.not(assigned_to_id: nil).each do |item|
      user_shares[item.assigned_to_id] += item.amount
    end

    # Split shared items equally among all users
    shared_items = items.where(assigned_to_id: nil)
    shared_items.each do |item|
      split_amount = item.amount / all_users_ids.size
      all_users_ids.each { |uid| user_shares[uid] += split_amount }
    end

    # Split tax equally among all users
    if tax.present? && tax > 0
      tax_per_user = tax / all_users_ids.size
      all_users_ids.each { |uid| user_shares[uid] += tax_per_user }
    end

    # Create ExpenseUser records
    user_shares.each do |user_id, amount|
      expense_users.create!(user_id: user_id, share_amount: amount.round(2))
    end
  end
end
