class UsersController < ApplicationController
  before_action :set_user, only: :show
  before_action :load_dashboard_data, only: [:index, :show]

  def index
    @users = User.exclude_user(current_user)
  end

  def show
    @expenses = @user.expenses.includes(:items, :expense_users)
    render :index
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def load_dashboard_data
    loader = DashboardLoader.new(current_user)
    @friends  = loader.friends
    @expenses = loader.expenses
  end
end
