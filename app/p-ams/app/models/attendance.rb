class Attendance < ApplicationRecord
  validates :working_date, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  has_many :break_times do
    def last_private
      where(break_type: :private_out).order(:id).last
    end
  end

  def create_regular_break
    noon_start = clock_in_at.change(hour: 12, min: 0)
    noon_end = clock_in_at.change(hour: 13, min: 0)
    if clock_in_at < noon_start && clock_out_at > noon_end
      unless break_times.regular.exists?
        break_times.create!(
          break_type: :regular,
          started_at: noon_start,
          ended_at:   noon_end
        )
      end
    end
  end

  def total_break_seconds
    breaks = break_times.where.not(started_at: nil).where.not(ended_at: nil)

    breaks.sum { |b| b.ended_at - b.started_at }
  end

  private
    def clock_out_after_clock_in
      return if clock_in_at.blank? || clcok_out_at.blank?

      if clock_out_at < clock_in_at
        errors.add(:clock_out_at, "は出勤時刻より後の時刻である必要があります。")
      end
    end
end
