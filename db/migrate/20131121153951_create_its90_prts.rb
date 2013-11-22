class CreateIts90Prts < ActiveRecord::Migration
  def change
    create_table :its90_prts do |t|
      t.string  :name,      null: false
      t.integer :sub_range, null: false
      t.float   :rtpw,      null: false, default: 25.0
      t.float   :a,         null: false, default:  0.0
      t.float   :b,         null: false, default:  0.0
      t.float   :c,         null: false, default:  0.0
      t.float   :d,         null: false, default:  0.0
      t.float   :w660,      null: false, default:  0.0
      t.float   :c1,        null: false, default:  0.0
      t.float   :c2,        null: false, default:  0.0
      t.float   :c3,        null: false, default:  0.0
      t.float   :c4,        null: false, default:  0.0
      t.float   :c5,        null: false, default:  0.0

      t.index   :name, unique: true

      t.timestamps
    end
  end
end
