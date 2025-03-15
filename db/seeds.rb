cpu_models = [
  "Intel Core i3", "Intel Core i5", "Intel Core i7", "Intel Core i9",
  "AMD Ryzen 3", "AMD Ryzen 5", "AMD Ryzen 7", "AMD Ryzen 9",
  "Apple M1", "Apple M2", "Apple M3"
]

50.times do
  Product.create!(
    name: Faker::Device.model_name,
    desc: Faker::Lorem.paragraph(sentence_count: 3),
    price: Faker::Number.between(from: 5_000_000, to: 50_000_000), 
    status: %w[available out_of_stock discontinued].sample,
    cpu: cpu_models.sample,
    ram: "#{Faker::Number.between(from: 4, to: 64)}GB",
    hard_disk: "#{Faker::Number.between(from: 128, to: 2000)}GB SSD",
    graphic_card: Faker::Device.manufacturer,
    screen: "#{Faker::Number.between(from: 13, to: 17)} inch",
    connection_port: Faker::Lorem.sentence(word_count: 5),
    keyboard: %w[mechanical membrane chiclet].sample,
    audio: "Stereo speakers",
    lan: "Gigabit Ethernet",
    wireless_lan: "Wi-Fi 6",
    webcam: "HD 720p",
    os: Faker::Computer.os,
    battery: "#{Faker::Number.between(from: 3, to: 8)} hours",
    weight: "#{Faker::Number.decimal(l_digits: 1, r_digits: 2)} kg",
    image_url: Faker::LoremFlickr.image(size: "300x300", search_terms: ['laptop'])
  )
end

puts "Seed completed!"
