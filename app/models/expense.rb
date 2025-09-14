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

  def split_expense!(participant_ids)
    expense_users.destroy_all
    participants = build_participants(participant_ids)
    user_shares = calculate_user_shares(participants)
    persist_user_shares(user_shares)
  end

  private

  def build_participants(participant_ids)
    users = User.where(id: participant_ids).to_a
    users << user unless users.include?(user)
    users
  end

  def calculate_user_shares(participants)
    shares = Hash.new(0)

    items.each do |item|
      if item.assigned_to_id.present?
        shares[item.assigned_to_id] += item.amount
      else
        per_person = item.amount.to_d / participants.size
        participants.each { |p| shares[p.id] += per_person }
      end
    end

    per_person_tax = (tax || 0).to_d / participants.size
    participants.each { |p| shares[p.id] += per_person_tax }

    shares
  end

  def persist_user_shares(shares)
    shares.each do |user_id, share_amount|
      expense_users.create!(user_id: user_id, share_amount: share_amount)
    end
  end

  def must_have_at_least_one_item
    if items.empty? || items.all? { |i| i.amount.blank? }
      errors.add(:items, "must have at least one with an amount")
    end
  end

  def calculate_total_amount
    item_total = items.sum { |item| item.amount.to_d }
    self.total_amount = item_total + (tax || 0)
  end
end
