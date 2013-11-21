class CreateIec60751Measurements < ActiveRecord::Migration
  def change
    create_table :iec60751_measurements do |t|
      t.float :temperature, required: true
      t.references :iec60751_prt, index: true

      t.timestamps
    end
  end
end
