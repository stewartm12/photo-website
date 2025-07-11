import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password"
export default class extends Controller {
  static targets = [
    "password", "passwordConfirmation",
    "togglePassword", "toggleConfirmation",
    "checkLength", "checkUpper", "checkLower", "checkNumber", "checkSpecial", "match"
  ]

  connect() {
    this.update()
  }

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

  update() {
    const password = this.passwordTarget.value
    const confirmation = this.passwordConfirmationTarget.value

    this.updateCheck(this.checkLengthTarget, password.length >= 11)
    this.updateCheck(this.checkUpperTarget, /[A-Z]/.test(password))
    this.updateCheck(this.checkLowerTarget, /[a-z]/.test(password))
    this.updateCheck(this.checkNumberTarget, /\d/.test(password))
    this.updateCheck(this.checkSpecialTarget, /[^A-Za-z0-9]/.test(password))

    this.updateCheck(this.matchTarget, password && password === confirmation)
  }

  updateCheck(target, valid) {
    if (!target) return;
  
    target.classList.toggle("text-green-600", valid);
    target.classList.toggle("text-gray-500", !valid);
  }
}
