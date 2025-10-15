import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rails-components--hello"
export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}
