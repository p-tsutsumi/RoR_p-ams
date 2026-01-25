class Attendance < ApplicationRecord
  validates :working_date, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  private
    def clock_out_after_clock_in
      return if clock_in_at.blank? || clcok_out_at.blank?

      if clock_out_at < clock_in_at
        errors.add(:clock_out_at, "は出勤時刻より後の時刻である必要があります。")
      end
    end
end
