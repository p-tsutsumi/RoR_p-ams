// app/javascript/controllers/clock_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date", "time"] // これを追加

  connect() {
    console.log("Clock controller connected!")
    this.updateTime()
    this.timer = setInterval(() => this.updateTime(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  updateTime() {
    const now = new Date()
    const dateString = now.toLocaleDateString('ja-JP', { 
      year: 'numeric', month: 'long', day: 'numeric', weekday: 'short' 
    })
    const timeString = now.toLocaleTimeString('ja-JP', { 
      hour12: false, hour: '2-digit', minute: '2-digit', second: '2-digit' 
    })

    // 自分の要素全体(this.element)を書き換えるのではなく、ターゲットだけを書き換える
    if (this.hasDateTarget) this.dateTarget.textContent = dateString
    if (this.hasTimeTarget) this.timeTarget.textContent = timeString
  }
}