import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="array-input"
export default class extends Controller {
  static targets = ["list", "wrapper", "emptyInput"]

  connect() {
    this.index = this.wrapperTarget.children.length
  }

  add(event) {
    event.preventDefault()

    const value = this.emptyInputTarget.value.trim()
    if (value.length === 0) {
      return // do nothing if empty
    }

    // Create new input with value and remove button
    const wrapperDiv = document.createElement('div')
    wrapperDiv.className = 'feature-field flex items-center gap-2 bg-gray-50'

    const input = document.createElement('input')
    input.type = 'text'
    input.name = 'package[features][]'
    input.value = value
    input.id = this.index

    const removeButton = document.createElement('button')
    removeButton.type = 'button'
    removeButton.textContent = 'Remove'
    removeButton.className = 'ml-2 text-red-500 hover:text-red-800 cursor-pointer'
    removeButton.setAttribute('data-action', 'array-input#remove')

    wrapperDiv.appendChild(input)
    wrapperDiv.appendChild(removeButton)
    this.wrapperTarget.appendChild(wrapperDiv)

    this.emptyInputTarget.value = ''
    this.index++
  }

  remove(event) {
    event.stopPropagation();
    event.target.closest(".feature-field").remove()
  }
}
