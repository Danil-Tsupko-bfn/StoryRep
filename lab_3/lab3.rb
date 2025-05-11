require 'json'
require 'yaml'

FILENAME = "autosalon_data.yaml"

class AutoSalon
  attr_accessor :name, :address, :cars, :phones

  def initialize(name, address, cars, phones)
    @name = name
    @address = address
    @cars = cars
    @phones = phones
  end

  def to_h
    {
      name: @name,
      address: @address,
      cars: @cars,
      phones: @phones
    }
  end

  def self.from_h(data)
    new(data[:name] || data['name'], data[:address] || data['address'],
        data[:cars] || data['cars'], data[:phones] || data['phones'])
  end

  def display
    puts "\nСалон: #{@name}"
    puts "Адреса: #{@address}"
    puts "Автомобілі: #{@cars.join(', ')}"
    puts "Телефони: #{@phones.join(', ')}"
  end
end

class AutoSalonDirectory
  def initialize
    @salons = {}
  end

  def add_salon(salon)
    @salons[salon.name] = salon
  end

  def edit_salon(name)
    salon = @salons[name]
    if salon
      puts "Нові дані (залиш порожнім, якщо не змінюєш):"

      print "Нова адреса: "
      address = gets.strip
      salon.address = address unless address.empty?

      print "Нові авто (через кому): "
      cars = gets.strip
      salon.cars = cars.split(",").map(&:strip) unless cars.empty?

      print "Нові телефони (через кому): "
      phones = gets.strip
      salon.phones = phones.split(",").map(&:strip) unless phones.empty?

      puts "Салон оновлено."
    else
      puts "Салон не знайдено."
    end
  end

  def delete_salon(name)
    if @salons.delete(name)
      puts "Салон видалено."
    else
      puts "Салон не знайдено."
    end
  end

  def find_salon(name)
    salon = @salons[name]
    salon ? salon.display : puts("Салон не знайдено.")
  end

  def list_salons
    if @salons.empty?
      puts "Немає жодного автосалону."
    else
      @salons.each_value(&:display)
    end
  end

  def save_to_file(filename, format = :json)
    data = @salons.values.map(&:to_h)

    case format
    when :json
      File.write(filename, JSON.pretty_generate(data))
    when :yaml
      File.write(filename, YAML.dump(data))
    else
      puts "Невідомий формат."
    end

    puts "Дані збережено у файл #{filename}"
  end

  def load_from_file(filename)
    raw = case File.extname(filename)
          when '.json'
            JSON.parse(File.read(filename), symbolize_names: true)
          when '.yaml', '.yml'
            YAML.load_file(filename)
          else
            puts "Невідомий формат файлу."
            return
          end

    @salons = raw.each_with_object({}) do |data, hash|
      salon = AutoSalon.from_h(data)
      hash[salon.name] = salon
    end

    puts "Дані завантажено з файлу #{filename}"
  end
end

# === Меню ===

def menu
  directory = AutoSalonDirectory.new

  directory.load_from_file(FILENAME) if File.exist?(FILENAME)

  loop do
    puts "\n--- МЕНЮ АВТОСАЛОНУ ---"
    puts "1. Переглянути всі салони"
    puts "2. Додати салон"
    puts "3. Знайти салон"
    puts "4. Редагувати салон"
    puts "5. Видалити салон"
    puts "6. Зберегти у файл"
    puts "7. Завантажити з файлу"
    puts "8. Вийти"
    print "Ваш вибір: "

    case gets.to_i
    when 1
      directory.list_salons
    when 2
      print "Назва салону: "
      name = gets.strip
      print "Адреса: "
      address = gets.strip
      print "Автомобілі (через кому): "
      cars = gets.strip.split(",").map(&:strip)
      print "Телефони (через кому): "
      phones = gets.strip.split(",").map(&:strip)

      salon = AutoSalon.new(name, address, cars, phones)
      directory.add_salon(salon)
      puts "Салон додано."
    when 3
      print "Введіть назву салону: "
      directory.find_salon(gets.strip)
    when 4
      print "Введіть назву салону для редагування: "
      directory.edit_salon(gets.strip)
    when 5
      print "Введіть назву салону для видалення: "
      directory.delete_salon(gets.strip)
    when 6
      print "Введіть ім'я файлу: "
      filename = gets.strip
      print "Формат (json/yaml): "
      format = gets.strip.to_sym
      directory.save_to_file(filename, format)
    when 7
      print "Введіть ім'я файлу: "
      filename = gets.strip
      directory.load_from_file(filename)
    when 8
      directory.save_to_file(FILENAME, :yaml)
      puts "Дані автоматично збережено у файл #{FILENAME}."
      puts "До побачення!"
      break
    else
      puts "Невірний вибір, спробуйте ще раз."
    end
  end
end
menu