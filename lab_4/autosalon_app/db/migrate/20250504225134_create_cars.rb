class AddDetailsToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :brand, :string unless column_exists?(:cars, :brand)
    add_column :cars, :year, :integer unless column_exists?(:cars, :year)
    add_column :cars, :model, :string unless column_exists?(:cars, :model) 
  end
end
