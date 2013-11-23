class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.float       :value, null: false
      t.string      :unit
      t.string      :quantity
      t.string      :type
      t.belongs_to  :meter, polymorphic: true

      t.timestamps
    end
    add_index :measurements, [:meter_id, :meter_type]
    # add_foreign_key :instruments, dependent: :restrict
  end
end
