require 'json'
require 'yaml'

FILENAME = "autosalon_data.yaml"  # Автофайл для збереження

class AutoSalonDirectory
  def initialize
    @contacts = {}
  end

  def add_contact(name, address, cars, phones)
    @contacts[name] = {
      address: address,
      cars: cars,
      phones: phones
    }
  end

  def edit_contact(name)
    if @contacts.key?(name)
      puts "Нові дані (залиш порожнім, якщо не змінюєш):"

      print "Нова адреса: "
      address = gets.strip
      @contacts[name][:address] = address unless address.empty?

      print "Нові авто (через кому): "
      cars = gets.strip
      @contacts[name][:cars] = cars.split(",").map(&:strip) unless cars.empty?

      print "Нові телефони (через кому): "
      phones = gets.strip
      @contacts[name][:phones] = phones.split(",").map(&:strip) unless phones.empty?

      puts "Салон оновлено."
    else
      puts "Салон не знайдено."
    end
  end

  def delete_contact(name)
    if @contacts.delete(name)
      puts "Салон видалено."
    else
      puts "Салон не знайдено."
    end
  end

  def find_contact(name)
    contact = @contacts[name]
    if contact
      display_contact(name, contact)
    else
      puts "Салон не знайдено."
    end
  end

  def list_contacts
    if @contacts.empty?
      puts "Немає жодного автосалону."
    else
      @contacts.each { |name, data| display_contact(name, data) }
    end
  end

  def save_to_file(filename, format = :json)
    case format
    when :json
      File.write(filename, JSON.pretty_generate(@contacts))
    when :yaml
      File.write(filename, YAML.dump(@contacts))
    else
      puts "Невідомий формат."
    end
    puts "Дані збережено у файл #{filename}"
  end

  def load_from_file(filename)
    case File.extname(filename)
    when '.json'
      @contacts = JSON.parse(File.read(filename), symbolize_names: true)
    when '.yaml', '.yml'
      @contacts = YAML.load_file(filename)
    else
      puts "Невідомий формат файлу."
    end
    puts "Дані завантажено з файлу #{filename}"
  end

  private

  def display_contact(name, data)
    puts "\nСалон: #{name}"
    puts "Адреса: #{data[:address]}"
    puts "Автомобілі: #{data[:cars].join(', ')}"
    puts "Телефони: #{data[:phones].join(', ')}"
  end
end

# === Меню ===

def menu
  directory = AutoSalonDirectory.new

  # Автоматичне завантаження
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
      directory.list_contacts
    when 2
      print "Назва салону: "
      name = gets.strip
      print "Адреса: "
      address = gets.strip
      print "Автомобілі (через кому): "
      cars = gets.strip.split(",").map(&:strip)
      print "Телефони (через кому): "
      phones = gets.strip.split(",").map(&:strip)
      directory.add_contact(name, address, cars, phones)
      puts "Салон додано."
    when 3
      print "Введіть назву салону: "
      directory.find_contact(gets.strip)
    when 4
      print "Введіть назву салону для редагування: "
      directory.edit_contact(gets.strip)
    when 5
      print "Введіть назву салону для видалення: "
      directory.delete_contact(gets.strip)
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
