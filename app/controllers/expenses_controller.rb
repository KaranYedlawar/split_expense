class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show edit update destroy]

  def create
    @expense = current_user.expenses.build(expense_params)

    if @expense.save
      @expense.split_expense!(params[:participants])
      redirect_to root_path, notice: "Expense was successfully created."
    else
      flash.now[:alert] = "Could not save expense. Please check the errors."
      @friends = User.joins(:expense_users)
                     .where(expense_users: { expense_id: current_user.shared_expenses.select(:id) })
                     .where.not(id: current_user.id)
                     .distinct
      @expenses = current_user.shared_expenses.includes(:expense_users, :items)
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
end
