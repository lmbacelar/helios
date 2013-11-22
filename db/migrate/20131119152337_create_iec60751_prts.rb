class CreateIec60751Prts < ActiveRecord::Migration
  def change
    create_table :iec60751_prts do |t|
      t.string :name, null: false
      t.float  :r0,   null: false, default: 100.0
      t.float  :a,    null: false, default:   3.9083e-03
      t.float  :b,    null: false, default:  -5.7750e-07
      t.float  :c,    null: false, default:  -4.1830e-12

      t.index  :name, unique: true

      t.timestamps
    end
  end
end
