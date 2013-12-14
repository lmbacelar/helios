class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.float       :value, null: false
      t.string      :unit
      t.string      :quantity
      t.string      :type
      t.belongs_to  :transfer_function, polymorphic: true

      t.timestamps
    end
    add_index :measurements, [:transfer_function_id, :transfer_function_type],
                             name:'index_measurements_on_transfer_function' 
    # add_foreign_key :instruments, dependent: :restrict
  end
end
