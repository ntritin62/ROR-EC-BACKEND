class InitModels < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :phone_number
      t.string :email
      t.integer :role, default: 0
      t.timestamps
    end
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :receiver_name
      t.text :place
      t.string :phone
      t.boolean :default
      t.timestamps
    end
    create_table :products do |t|
      t.string :name
      t.text :desc
      t.float :price
      t.float :rating
      t.string :status
      t.string :cpu
      t.string :ram
      t.string :hard_disk
      t.string :graphic_card
      t.string :screen
      t.text :connection_port
      t.string :keyboard
      t.string :audio
      t.string :lan
      t.string :wireless_lan
      t.string :webcam
      t.string :os
      t.string :battery
      t.string :weight
      t.text :image_url
      t.timestamps
    end
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    create_table :cart_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true
      t.timestamps
    end
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, foreign_key: true
      t.string :payment_method
      t.integer :status, default: 0
      t.float :total
      t.timestamps
    end
    create_table :order_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.float :price
      t.timestamps
    end
  end
end
