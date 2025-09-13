class Expense < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :expense_users, dependent: :destroy
  has_many :participants, through: :expense_users, source: :user

  accepts_nested_attributes_for :items, allow_destroy: true

  validates :description, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :tax, numericality: { greater_than_or_equal_to: 0 }
  validate  :must_have_at_least_one_item

  before_validation :calculate_total_amount

  # Splits expense equally among participants and creates ExpenseUser records
  def split_expense!(participant_ids)
    expense_users.destroy_all

    participants = User.where(id: participant_ids)
    participants = participants.to_a.push(user) unless participants.include?(user)

    per_person_share = total_amount.to_d / participants.size

    participants.each do |participant|
      expense_users.create!(
        user: participant,
        share_amount: per_person_share
      )
    end
  end

  private

  def must_have_at_least_one_item
    if items.empty? || items.all? { |i| i.amount.blank? }
      errors.add(:items, "must have at least one with an amount")
    end
  end

  def calculate_total_amount
    item_total = items.map { |item| item.amount.to_d }.sum
    self.total_amount = item_total + (tax || 0)
  end
end

