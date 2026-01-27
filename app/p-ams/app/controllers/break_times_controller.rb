class BreakTimesController < ApplicationController
  def create
    attendance = Attendance.find(params[:attendance_id])
    last_break = attendance.break_times.last_private
    type = params[:type]

    case [last_break&.started_at.present?, last_break&.ended_at.present?, type]
    in [true, false, "end"]
      # 休憩開始時刻がある状態で、休憩終了が押下されたら更新。
      last_break.update(ended_at: Time.current)
      @break_time = last_break
    else
      # 上記以外は新規レコード作成。休憩の異常レコードは、修正申請で修正してもらう運用。
      @break_time = new_break_time_record(attendance, type)
      unless @break_time.save
        redirect_to attendances_path, alert: "休憩は1日3回までです"
        return
      end
    end

    redirect_to attendances_path, notice: "休憩を記録しました"
  end

  private
    def new_break_time_record(attendance, type)
      now = Time.current
      attendance.break_times.new(
        break_type: :private_out,
        started_at: type == "start" ? now : nil,
        ended_at: type == "end" ? now : nil,
      )
    end
end
