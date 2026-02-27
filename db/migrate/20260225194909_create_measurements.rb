class CreateMeasurements < ActiveRecord::Migration[8.1]
  def change
    create_table :measurements do |t|
      t.string :zone
      t.string :meter_number
      t.integer :meter_measurement, default: 0
      t.string :meter_serie
      t.string :meter_model
      t.string :description
      t.string :observation

      t.timestamps
    end
  end
end
