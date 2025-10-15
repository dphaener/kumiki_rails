import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rails-components--dismiss"
export default class extends Controller {
  static targets = ["element"]
  static classes = ["animation"]

  // Remove the target element from the DOM with animation
  dismiss() {
    // If we have specific targets, use those, otherwise dismiss the controller's element
    const elementsToRemove = this.hasElementTarget ? this.elementTargets : [this.element]

    elementsToRemove.forEach(element => {
      // Use configurable animation if specified
      if (this.hasAnimationClass) {
        element.classList.add(...this.animationClasses)

        // Remove element after animation completes
        setTimeout(() => {
          element.remove()
        }, 300) // Match the CSS animation duration
      } else {
        // Fallback: immediate removal
        element.remove()
      }
    })
  }

  // Hide the target element using CSS classes
  hide() {
    this.elementTargets.forEach(element => {
      element.style.display = "none"
    })
  }

  // Alternative method for hiding with CSS classes
  // Useful when you want to maintain DOM structure but hide visually
  hideWithClass(event) {
    const className = event.params?.class || "hidden"
    this.elementTargets.forEach(element => {
      element.classList.add(className)
    })
  }
}
