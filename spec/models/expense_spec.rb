require "rails_helper"

RSpec.describe Expense, type: :model do
  describe "#calculate_total_amount" do
    it "sums up item amounts + tax" do
      expense = build(:expense, tax: 5)
      expense.items.destroy_all
      expense.items << build(:item, amount: 10, expense: expense)
      expense.items << build(:item, amount: 20, expense: expense)

      expense.valid? # triggers before_validation -> calculate_total_amount

      expect(expense.total_amount.to_f).to eq(35.0)
    end

    it "sets total_amount to just tax if no items present" do
      expense = build(:expense, tax: 10)
      expense.items.destroy_all

      expense.valid?

      expect(expense.total_amount.to_f).to eq(10.0)
    end
  end

  describe "#split_expense!" do
    let(:user) { create(:user) }
    let(:friend1) { create(:user) }
    let(:friend2) { create(:user) }

    it "splits equally among participants" do
      expense = create(:expense, user: user, tax: 0)
      expense.items.destroy_all
      expense.items << create(:item, expense: expense, amount: 30)

      expense.split_expense!([friend1.id, friend2.id])

      shares = expense.expense_users.pluck(:share_amount)
      expect(shares.map(&:to_f)).to all(eq(10.0))
    end

    it "assigns full amount to specific user if item is assigned" do
      expense = create(:expense, user: user, tax: 0)
      expense.items.destroy_all
      expense.items << create(:item, expense: expense, amount: 30, assigned_to: friend1)

      expense.split_expense!([friend1.id, friend2.id])

      shares = expense.expense_users.pluck(:user_id, :share_amount).to_h
      expect(shares[friend1.id].to_f).to eq(30.0)
      expect(shares[user.id].to_f).to eq(0.0)
      expect(shares[friend2.id].to_f).to eq(0.0)
    end

    it "splits tax equally across participants" do
      expense = create(:expense, user: user, tax: 9)
      expense.items.destroy_all
      expense.items << create(:item, expense: expense, amount: 10)

      expense.split_expense!([friend1.id, friend2.id])

      shares = expense.expense_users.pluck(:share_amount)
      expect(shares.map(&:to_f)).to all(eq(6.33))
    end
  end
end
