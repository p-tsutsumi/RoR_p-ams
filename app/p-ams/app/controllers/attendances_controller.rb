class AttendancesController < ApplicationController
  def index
    @current_attendance = Attendance.find_by(
      user_id: session[:user_sub],
      working_date: Date.current
    )
  end
end
