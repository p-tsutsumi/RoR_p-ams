class BreakTime < ApplicationRecord
  MAX_BREAKS_PER_DAY = 3
  belongs_to :attendance
  validate :check_max_breaks, on: :create

  enum break_type: { regular: 0, private_out: 1 }

  private
    def check_max_breaks
      if attendance.break_times.where(break_type: :private_out).count >= MAX_BREAKS_PER_DAY
        errors.add(:base, "1日の休憩打刻は最大#{MAX_BREAKS_PER_DAY}回までです。")
      end
    end
end
