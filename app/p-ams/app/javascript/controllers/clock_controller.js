import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.updateTime()
    this.timer = setInterval(() => {
      this.updateTime()
    }, 1000)
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

    document.getElementById('current-date').textContent = dateString
    this.element.textContent = timeString
  }
}