class CreateIec60584Functions < ActiveRecord::Migration
  def change
    create_table :iec60584_functions do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.float  :a3,   null: false, default: 0.0
      t.float  :a2,   null: false, default: 0.0
      t.float  :a1,   null: false, default: 0.0
      t.float  :a0,   null: false, default: 0.0

      t.index   :name, unique: true

      t.timestamps
    end
  end
end
