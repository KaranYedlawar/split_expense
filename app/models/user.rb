class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :expenses, dependent: :destroy
  has_many :assigned_items, class_name: "Item", foreign_key: "assigned_to_id", dependent: :nullify
  has_many :expense_users, dependent: :destroy
  has_many :shared_expenses, through: :expense_users, source: :expense

  validates :name, presence: true
  validates :mobile_number, format: { with: /\A[0-9]{10}\z/, message: "must be 10 digits" }, allow_blank: true

  scope :exclude_user, ->(user) { where.not(id: user.id) }
  scope :dashboard_friends, ->(user) { friends_with(user) }

  scope :friends_with, ->(user) {
    joins(:expense_users)
      .where(expense_users: { expense_id: user.shared_expenses.select(:id) })
      .where.not(id: user.id)
      .distinct
  }

  def total_balance
    total_you_are_owed - total_you_owe
  end

  def total_you_owe
    ExpenseUser.owed_by(self)
  end

  def total_you_are_owed
    ExpenseUser.owed_to(self)
  end

  def friend_owes_you(friend)
    ExpenseUser.where(user: friend)
               .joins(:expense)
               .where(expenses: { user_id: id })
               .sum(:share_amount)
  end

  def you_owe_friend(friend)
    ExpenseUser.where(user: self)
               .joins(:expense)
               .where(expenses: { user_id: friend.id })
               .sum(:share_amount)
  end
end
