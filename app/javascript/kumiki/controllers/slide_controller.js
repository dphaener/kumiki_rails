import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rails-components--slide"
export default class extends Controller {
  static classes = ["in", "out"]

  // Slide element in
  slideIn() {
    // Remove any existing slide classes
    this.element.classList.remove(...this.outClasses)

    // Add the slide-in classes
    this.element.classList.add(...this.inClasses)

    // Dispatch event for coordination with other controllers
    this.dispatch("slide-in", {
      detail: { element: this.element }
    })
  }

  // Slide element out
  slideOut() {
    // Remove any existing slide classes
    this.element.classList.remove(...this.inClasses)

    // Add the slide-out classes
    this.element.classList.add(...this.outClasses)

    // Dispatch event for coordination with other controllers
    this.dispatch("slide-out", {
      detail: { element: this.element }
    })
  }

  // Toggle between slide in and slide out
  toggle() {
    if (this.isSlideIn()) {
      this.slideOut()
    } else {
      this.slideIn()
    }
  }

  // Check if element is currently slid in
  isSlideIn() {
    return this.inClasses.some(className =>
      this.element.classList.contains(className)
    )
  }

  // Check if element is currently slid out
  isSlideOut() {
    return this.outClasses.some(className =>
      this.element.classList.contains(className)
    )
  }

  // Reset - remove all slide classes
  reset() {
    this.element.classList.remove(...this.inClasses, ...this.outClasses)

    this.dispatch("slide-reset", {
      detail: { element: this.element }
    })
  }
}
