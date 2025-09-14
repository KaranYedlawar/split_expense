class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show edit update destroy]
  before_action :load_dashboard_data, only: [:create]

  def create
    @expense = current_user.expenses.build(expense_params)

    if @expense.save
      @expense.split_expense!(params[:participants] || [])
      redirect_to root_path, notice: "Expense was successfully created."
    else
      flash.now[:alert] = "Could not save expense. Please check the errors."
      render "static/dashboard", status: :unprocessable_entity
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(
      :description, :tax,
      items_attributes: [:id, :name, :amount, :assigned_to_id, :_destroy]
    )
  end

  def load_dashboard_data
    loader = DashboardLoader.new(current_user)
    @friends  = loader.friends
    @expenses = loader.expenses
  end
end

