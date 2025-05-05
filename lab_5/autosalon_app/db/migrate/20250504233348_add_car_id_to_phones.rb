class AddCarIdToPhones < ActiveRecord::Migration[7.1]
  def change
    add_column :phones, :car_id, :integer
  end
end
