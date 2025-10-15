import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rails-components--auto-dismiss"
export default class extends Controller {
  static values = {
    delay: { type: Number, default: 5000 } // Default 5 second delay
  }
  static classes = ["animation"]

  connect() {
    this.startTimer()
  }

  disconnect() {
    this.clearTimer()
  }

  // Start the auto-dismiss timer
  startTimer() {
    this.clearTimer() // Clear any existing timer
    this.timer = setTimeout(() => {
      this.autoDismiss()
    }, this.delayValue)
  }

  // Clear the timer (useful for manual dismissal)
  clearTimer() {
    if (this.timer) {
      clearTimeout(this.timer)
      this.timer = null
    }
  }

  // Auto-dismiss the element
  autoDismiss() {
    // Dispatch a custom event that other controllers can listen to
    this.dispatch("auto-dismiss", {
      detail: { element: this.element }
    })

    // Use configurable animation if specified
    if (this.hasAnimationClass) {
      this.element.classList.add(...this.animationClasses)

      // Remove element after animation completes
      // Use 320ms instead of 300ms to ensure animation fully completes before removal
      setTimeout(() => {
        this.element.style.display = 'none' // Hide immediately
        this.element.remove()
      }, 320) // Slightly longer than CSS animation duration
    } else {
      // Default behavior: immediate removal
      this.element.remove()
    }
  }

  // Reset the timer (useful if user interacts with element)
  resetTimer() {
    this.startTimer()
  }

  // Pause the timer
  pauseTimer() {
    this.clearTimer()
  }

  // Resume the timer
  resumeTimer() {
    this.startTimer()
  }
}
