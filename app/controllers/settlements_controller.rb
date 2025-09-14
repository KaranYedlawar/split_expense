class SettlementsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:friend_id])
    amount = params[:amount].to_d


    begin
      current_user.settle_up_with(friend, amount)
      redirect_back(fallback_location: dashboard_path, notice: "Successfully settled up with #{friend.name}")
    rescue => e
      redirect_back(fallback_location: dashboard_path, alert: e.message)
    end
  end
end
