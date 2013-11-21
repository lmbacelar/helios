class CreatePrtMeasurements < ActiveRecord::Migration
  def change
    create_table :prt_measurements do |t|
      t.float :temperature, required: true
      t.references :iec60751_prt, index: true

      t.timestamps
    end
  end
end
