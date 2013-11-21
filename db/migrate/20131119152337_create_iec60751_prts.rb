class CreateIec60751Prts < ActiveRecord::Migration
  def change
    create_table :iec60751_prts do |t|
      t.string :name, required: true
      t.float  :r0,   required: true, default: 100.0
      t.float  :a,    required: true, default:   3.9083e-03
      t.float  :b,    required: true, default:  -5.7750e-07
      t.float  :c,    required: true, default:  -4.1830e-12

      t.timestamps
    end
  end
end
