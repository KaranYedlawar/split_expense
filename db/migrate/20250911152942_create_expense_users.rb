class CreateExpenseUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :expense_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :expense, null: false, foreign_key: true
      t.decimal :share_amount, precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end
end
