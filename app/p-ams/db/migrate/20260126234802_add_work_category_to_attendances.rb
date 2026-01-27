class AddWorkCategoryToAttendances < ActiveRecord::Migration[7.1]
  def change
    # 0:通常勤務, 1:テレワーク, 2:年休, 3:半休
    add_column :attendances, :work_category, :integer, default: 0, null: false
  end
end
