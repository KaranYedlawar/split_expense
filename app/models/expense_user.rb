class ExpenseUser < ApplicationRecord
  belongs_to :user
  belongs_to :expense

  validates :share_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, uniqueness: { scope: :expense_id, message: "already has a share for this expense" }

  # Total amount a user owes others (exclude self created)
  scope :owed_by, ->(user) {
    joins(:expense)
      .where(user: user)
      .where.not(expenses: { user_id: user.id })
      .sum(:share_amount)
  }

  # Total amount owed to a user (exclude self)
  scope :owed_to, ->(user) {
    joins(:expense)
      .where(expenses: { user_id: user.id })
      .where.not(user_id: user.id)
      .sum(:share_amount)
  }
end
