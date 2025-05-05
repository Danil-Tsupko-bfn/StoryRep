rails console

load 'lib/auto_salon_importer.rb'

AutoSalonImporter.import_from_yaml("autosalon_data.yaml")

AutoSalon.destroy_all


salon = AutoSalon.create!(name: "АвтоСвіт", address: "вул. Київська, 10")
salon.cars.create!(name: "Toyota")
salon.phones.create!(number: "0501234567")

////

AutoSalon.includes(cars: :phones).each do |auto_salon|
  puts "AutoSalon Name: #{auto_salon.name}, Address: #{auto_salon.address}"

  auto_salon.cars.each do |car|
    puts "  Car Brand: #{car.brand}, Model: #{car.model}, Year: #{car.year}"
    car.phones.each do |phone|
      puts "    Phone Number: #{phone.number}"
    end
  end

  puts "--------------------------"
end

