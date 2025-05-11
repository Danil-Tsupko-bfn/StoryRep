class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :name
      t.references :salon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
