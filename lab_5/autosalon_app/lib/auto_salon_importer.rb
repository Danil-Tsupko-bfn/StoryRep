require 'yaml'

class AutoSalonImporter
  def self.import_from_yaml(filename)
    data = YAML.load_file(filename)

    data.each do |salon_data|
      salon = AutoSalon.find_or_create_by!(
        name: salon_data['name']
      ) do |s|
        s.address = salon_data['address']
      end

      salon_data['cars']&.each do |car_data| 
        salon.cars.find_or_create_by!(
          brand: car_data['brand'],
          model: car_data['model'],
          year: car_data['year']
        )
      end

      salon_data['phones']&.each do |phone_number|
        salon.phones.find_or_create_by!(number: phone_number)
      end
    end

    puts "✅ Імпорт завершено."
  end
end
