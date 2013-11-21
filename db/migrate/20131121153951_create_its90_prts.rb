class CreateIts90Prts < ActiveRecord::Migration
  def change
    create_table :its90_prts do |t|
      t.string  :name,      required: true
      t.integer :sub_range, required: true
      t.float   :rtpw,      required: true, default: 25.0
      t.float   :a,         required: true, default:  0.0
      t.float   :b,         required: true, default:  0.0
      t.float   :c,         required: true, default:  0.0
      t.float   :d,         required: true, default:  0.0
      t.float   :w660,      required: true, default:  0.0
      t.float   :c1,        required: true, default:  0.0
      t.float   :c2,        required: true, default:  0.0
      t.float   :c3,        required: true, default:  0.0
      t.float   :c4,        required: true, default:  0.0
      t.float   :c5,        required: true, default:  0.0

      t.timestamps
    end
  end
end
