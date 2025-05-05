class CreateAutoSalons < ActiveRecord::Migration[7.1]
  def change
    create_table :auto_salons do |t|
      t.string :name
      t.string :address

      t.timestamps
    end
  end
end
