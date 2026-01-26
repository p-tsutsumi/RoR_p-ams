class CreateBreakTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :break_times do |t|
      t.references :attendance, null: false, foreign_key: true
      t.integer :break_type
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
