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

  private
    def set_current_attendance
      @current_attendance = Attendance.find_by(
        user_id: session[:user_id],
        working_date: Date.current
      )
    end
end
