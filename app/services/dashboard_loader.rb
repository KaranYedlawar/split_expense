class DashboardLoader
  attr_reader :user

  def initialize(user)
    @user = user
  end

  # Returns friends of the current user (people who share expenses with them)
  def friends
    User.friends_with(user)
  end

  # Returns all shared expenses for the current user with preloaded associations to avoid N+1
  def expenses
    user.shared_expenses.includes(:items, :expense_users)
  end
end