class StaticController < ApplicationController
  def dashboard
    load_dashboard_data
    @expense = Expense.new
    @expense.items.build
  end

  private

  # Method to load friends + expenses
  def load_dashboard_data
    loader = DashboardLoader.new(current_user)
    @friends  = loader.friends
    @expenses = loader.expenses
  end
end
