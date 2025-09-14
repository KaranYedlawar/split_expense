class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :expenses, dependent: :destroy
  has_many :assigned_items, class_name: "Item", foreign_key: "assigned_to_id", dependent: :nullify
  has_many :expense_users, dependent: :destroy
  has_many :shared_expenses, through: :expense_users, source: :expense

  validates :name, presence: true

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

  def net_balance_with(friend)
    you_owe = you_owe_friend(friend)
    friend_owes = friend_owes_you(friend)
    you_owe - friend_owes
  end

  def settle_up_with(friend, amount)
    raise "Amount must be greater than 0" if amount <= 0

    net_amount = net_balance_with(friend)
    raise "No payment needed. Your friend owes you more." if net_amount <= 0
    raise "Amount exceeds what you owe after netting." if amount > net_amount

    ActiveRecord::Base.transaction do
      reduce_debt_towards(friend, amount)
    end
  end

  private

  def reduce_debt_towards(friend, amount)
    remaining = amount
    expense_users.joins(:expense)
                 .where(expenses: { user_id: friend.id })
                 .order(:created_at)
                 .each do |eu|
      break if remaining <= 0

      pay = [eu.share_amount, remaining].min
      eu.update!(share_amount: eu.share_amount - pay)
      remaining -= pay
    end
  end
end
