class StaticController < ApplicationController
  def dashboard
    @friends  = User.friends_with(current_user)
    @expenses = current_user.shared_expenses.includes(:expense_users, :items)

    @expense = Expense.new
    @expense.items.build
  end

  def people
    @friends = User.exclude_user(current_user)
  end
end
