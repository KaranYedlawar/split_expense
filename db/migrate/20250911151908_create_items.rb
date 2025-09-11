class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.references :expense, null: false, foreign_key: true
      t.bigint :assigned_to_id
      t.timestamps
    end
    
    add_foreign_key :items, :users, column: :assigned_to_id
  end
end
