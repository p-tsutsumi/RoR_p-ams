class AttendancesController < ApplicationController
  before_action :set_current_attendance, only: [:index, :create, :clock_out]
  def index
  end

  def create
    @current_attendance ||= Attendance.new(
      user_id: session[:user_id],
      working_date: Date.current
    )
    if @current_attendance.clock_in_at.present?
      redirect_to attendances_path, alert: "すでに出勤済みです。"
    elsif @current_attendance.update(clock_in_at: Time.current)
      redirect_to attendances_path, notice: "出勤しました。"
    else
      redirect_to attendances_path, alert: "出勤処理に失敗しました。"
    end
  end

  def clock_out
    if @current_attendance.nil?
      redirect_to attendances_path, alert: "本日の出勤データが見つかりません。"
    elsif @current_attendance.clock_out_at.present?
      redirect_to attendances_path, alert: "すでに退勤済みです。"
    elsif @current_attendance.update(clock_out_at: Time.current)
      redirect_to attendances_path, notice: "退勤しました。"
    else
      redirect_to attendances_path, alert: "退勤処理に失敗しました。"
    end
  end

  def history
    @target_date = params[:date] ? Date.parse(params[:date]) : Date.current
    @start_date = @target_date.beginning_of_month
    @end_date = @target_date.end_of_month
    @calendar_days = (@start_date..@end_date).to_a

    attendances_array = Attendance.where(user_id: session[:user_id])
                                     .where(working_date: @start_date..@end_date)

    # Viewで日付から索引しやすいようにハッシュ化
    @monthly_attendances = attendances_array.index_by(&:working_date)


    # 出勤データを算出するために、出勤・退勤処理が完了したデータを抽出
    working_records = attendances_array.select { |a| a.clock_in_at.present? && a.clock_out_at.present? }

    @working_days_count = working_records.length
    @total_working_hours = (working_records.sum { |a| a[:clock_out_at] - a[:clock_in_at] } / 3600.0).round(1)
  end

  private
    def set_current_attendance
      @current_attendance = Attendance.find_by(
        user_id: session[:user_id],
        working_date: Date.current
      )
    end
end
