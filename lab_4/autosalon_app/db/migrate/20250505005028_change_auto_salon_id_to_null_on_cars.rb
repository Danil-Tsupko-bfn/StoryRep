class ChangeAutoSalonIdToNullOnCars < ActiveRecord::Migration[7.1]
  def change
    change_column_null :cars, :auto_salon_id, true
  end
end
