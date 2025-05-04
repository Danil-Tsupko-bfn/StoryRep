require 'json'
require 'yaml'

FILENAME = "contacts_data.yaml"  # Автофайл для збереження

class PhoneBook
  def initialize
    @contacts = {}
  end

  # Додавання нового контакту
  def add_contact(name, phones)
    @contacts[name] = phones
  end

  # Редагування існуючого контакту
  def edit_contact(name)
    if @contacts.key?(name)
      puts "Нові телефони (залиш порожнім, якщо не змінюєш):"
      
      print "Телефони (через кому): "
      phones = gets.strip.split(",").map(&:strip)
      @contacts[name] = phones unless phones.empty?

      puts "Контакт оновлено."
    else
      puts "Контакт не знайдено."
    end
  end

  # Видалення контакту
  def delete_contact(name)
    if @contacts.delete(name)
      puts "Контакт видалено."
    else
      puts "Контакт не знайдено."
    end
  end

  # Пошук контакту
  def find_contact(name)
    contact = @contacts[name]
    if contact
      display_contact(name, contact)
    else
      puts "Контакт не знайдено."
    end
  end

  # Перегляд всіх контактів
  def list_contacts
    if @contacts.empty?
      puts "Немає жодного контакту."
    else
      @contacts.each { |name, phones| display_contact(name, phones) }
    end
  end

  # Збереження контактів у файл
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

  # Завантаження контактів з файлу
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

  def display_contact(name, phones)
    puts "\nКонтакт: #{name}"
    puts "Телефони: #{phones.join(', ')}"
  end
end

# === Меню ===

def menu
  phonebook = PhoneBook.new

  # Автоматичне завантаження
  phonebook.load_from_file(FILENAME) if File.exist?(FILENAME)

  loop do
    puts "\n--- МЕНЮ ТЕЛЕФОННОГО ДОВІДНИКА ---"
    puts "1. Переглянути всі контакти"
    puts "2. Додати контакт"
    puts "3. Знайти контакт"
    puts "4. Редагувати контакт"
    puts "5. Видалити контакт"
    puts "6. Зберегти у файл"
    puts "7. Завантажити з файлу"
    puts "8. Вийти"
    print "Ваш вибір: "

    case gets.to_i
    when 1
      phonebook.list_contacts
    when 2
      print "Ім'я контакту: "
      name = gets.strip
      print "Телефони (через кому): "
      phones = gets.strip.split(",").map(&:strip)
      phonebook.add_contact(name, phones)
      puts "Контакт додано."
    when 3
      print "Введіть ім'я контакту: "
      phonebook.find_contact(gets.strip)
    when 4
      print "Введіть ім'я контакту для редагування: "
      phonebook.edit_contact(gets.strip)
    when 5
      print "Введіть ім'я контакту для видалення: "
      phonebook.delete_contact(gets.strip)
    when 6
      print "Введіть ім'я файлу: "
      filename = gets.strip
      print "Формат (json/yaml): "
      format = gets.strip.to_sym
      phonebook.save_to_file(filename, format)
    when 7
      print "Введіть ім'я файлу: "
      filename = gets.strip
      phonebook.load_from_file(filename)
    when 8
      phonebook.save_to_file(FILENAME, :yaml)
      puts "Дані автоматично збережено у файл #{FILENAME}."
      puts "До побачення!"
      break
    else
      puts "Невірний вибір, спробуйте ще раз."
    end
  end
end

menu
