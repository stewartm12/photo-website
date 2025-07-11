import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="session"
export default class extends Controller {
  toggleVisibility(event) {
    const button = event.currentTarget
    const input = button.previousElementSibling

    if (input && input.type === "password") {
      input.type = "text"
      button.textContent = "Hide"
    } else if (input) {
      input.type = "password"
      button.textContent = "Show"
    }
  }
}
