require "rails_helper"

RSpec.describe ExpensesController, type: :request do
  let(:user)   { create(:user) }
  let(:friend) { create(:user) }

  before do
    sign_in user
  end

  describe "POST /expenses" do
    let(:valid_params) do
      {
        expense: {
          description: "Dinner",
          tax: 10,
          items_attributes: [
            { name: "Pizza", amount: 200 }
          ]
        },
        participants: [friend.id]
      }
    end

    let(:invalid_params) do
      {
        expense: {
          description: "",
          tax: 10,
          items_attributes: [
            { name: "Pizza", amount: 200 }
          ]
        }
      }
    end

    context "with valid params" do
      it "creates a new expense" do
        expect {
          post expenses_path, params: valid_params
        }.to change(Expense, :count).by(1)
      end

      it "calls split_expense! with participants" do
        expect_any_instance_of(Expense)
          .to receive(:split_expense!)
          .with([friend.id.to_s])
        post expenses_path, params: valid_params
      end

      it "redirects to root path with success message" do
        post expenses_path, params: valid_params
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Expense was successfully created.")
      end
    end

    context "with invalid params" do
      it "does not create a new expense" do
        expect {
          post expenses_path, params: invalid_params
        }.not_to change(Expense, :count)
      end

      it "renders dashboard with error message" do
        post expenses_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Could not save expense")
      end
    end
  end
end
