class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.float       :value, null: false
      t.string      :unit
      t.string      :quantity
      t.string      :type
      t.belongs_to  :its90_function
      t.belongs_to  :iec60751_function

      t.foreign_key :its90_functions,    dependent: :restrict
      t.foreign_key :iec60751_functions, dependent: :restrict

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE measurements ADD CONSTRAINT transfer_function_xor
          CHECK(
            (its90_function_id    is not null)::integer +
            (iec60751_function_id is not null)::integer = 1
          );
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE measurements DROP CONSTRAINT transfer_function_xor;
        SQL
      end
    end
  end
end
