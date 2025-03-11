class AddPaymentFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :client_secret, :string
    add_column :orders, :payment_intent_id, :string
  end
end
