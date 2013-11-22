class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.float  :value, null: false
      t.string :unit
      t.string :quantity
      t.string :type
      t.references :instrument, index: true

      t.timestamps
    end
  end
end
