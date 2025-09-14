require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }

  describe "#settle_up_with" do
    before do
      expense = create(:expense, user: friend)
      create(:item, expense: expense, amount: 20)
      expense.split_expense!([user.id, friend.id])
    end

    it "reduces your debt when you pay part of it" do
      expect(user.you_owe_friend(friend)).to eq(10)

      user.settle_up_with(friend, 5)

      expect(user.you_owe_friend(friend)).to eq(5)
    end

    it "reduces debt completely when paying full amount" do
      full_amount = user.you_owe_friend(friend)
      user.settle_up_with(friend, full_amount)

      expect(user.you_owe_friend(friend)).to eq(0)
    end

    it "raises error when paying more than owed" do
      full_amount = user.you_owe_friend(friend)
      expect {
        user.settle_up_with(friend, full_amount + 1)
      }.to raise_error("Amount exceeds what you owe after netting.")
    end

    it "does not allow negative or zero payment" do
      expect { user.settle_up_with(friend, 0) }.to raise_error("Amount must be greater than 0")
      expect { user.settle_up_with(friend, -5) }.to raise_error("Amount must be greater than 0")
    end

    it "netting works if friend owes you" do
        before_user_owes = user.you_owe_friend(friend)
        before_friend_owes = friend.friend_owes_you(user)

        user.settle_up_with(friend, 5)

        after_user_owes = user.you_owe_friend(friend)
        after_friend_owes = friend.friend_owes_you(user)

        expect(after_user_owes).to eq(before_user_owes - 5)
        expect(after_friend_owes).to eq([before_friend_owes - 5, 0].max)
    end
  end

  describe "#total_balance" do
    it "calculates total balance correctly" do
      expense = create(:expense, user: friend)
      create(:item, expense: expense, amount: 20)
      expense.split_expense!([user.id, friend.id])

      expect(user.total_balance).to eq(-10)
      expect(friend.total_balance).to eq(10)
    end
  end
end
