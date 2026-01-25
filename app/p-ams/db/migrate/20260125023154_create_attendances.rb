class CreateAttendances < ActiveRecord::Migration[7.1]
  def change
    create_table :attendances do |t|
      t.string :user_id
      t.date :working_date
      t.datetime :clock_in_at
      t.datetime :clock_out_at
      t.text :note

      t.timestamps
    end
    add_index :attendances, :user_id
    add_index :attendances, :working_date
  end
end
