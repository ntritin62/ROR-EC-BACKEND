class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :desc, :created_at, :updated_at,
             :cpu, :ram, :hard_disk, :screen, :keyboard, :audio, :lan, 
             :webcam, :os, :battery, :weight, :status,
             :graphic_card, :connection_port, :wireless_lan, :image_url
end
