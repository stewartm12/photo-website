import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="appointment-add-on"
export default class extends Controller {
  static targets = ["list", "addOnSelect", "addOnQuantity", "addon"]

  connect() {
    this.index = this.listTarget.children.length
  }

  remove(event) {
    event.stopPropagation();

    const button = event.currentTarget
    const addonElement = button.closest("[data-appointment-add-on-target='addon']")
    addonElement.remove()
  }

  add() {
    const addOnId = this.addOnSelectTarget.value
    const addOnName = this.addOnSelectTarget.options[this.addOnSelectTarget.selectedIndex]?.text
    const quantity = parseInt(this.addOnQuantityTarget.value, 10)

    if (!addOnId || !quantity) return

    // Retrieve the price for the selected add-on using the lookup map created in `connect`.
    const selectedOption = this.addOnSelectTarget.options[this.addOnSelectTarget.selectedIndex]
    const addOnPrice = selectedOption?.dataset.price
    // Format the price as currency for display purposes.
    const formattedPrice = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }).format(addOnPrice);

      // Check if add-on already exists
    const existingAddon = this.addonTargets.find(
      (el) => el.querySelector(`input[name*='[add_on_id]']`)?.value === addOnId
    )

    if (existingAddon) {
      // Update quantity
      const quantityInput = existingAddon.querySelector("input[type='number']")
      quantityInput.value = parseInt(quantityInput.value, 10) + quantity

    } else {
      // Create new entry
      const wrapper = document.createElement("div")
      wrapper.className = "flex items-center justify-between p-3 bg-gray-50 rounded-md"
      wrapper.setAttribute("data-appointment-add-on-target", "addon")

      wrapper.innerHTML = `
        <div class="flex-1">
          <div class="flex items-center gap-2">
            <span class="font-medium">${addOnName}</span>
          </div>
          <span class="text-sm text-gray-500">${formattedPrice} each</span>
        </div>
        <div class="flex items-center gap-3">
          <input type="hidden" name="appointment[appointment_add_ons_attributes][${this.index}][add_on_id]" value="${addOnId}" />
          <input type="number" name="appointment[appointment_add_ons_attributes][${this.index}][quantity]" value="${quantity}" min="1" class="border rounded-md px-2 py-1 w-16" />
          <button type="button" data-action="appointment-add-on#remove" class="text-red-500 hover:text-red-600 hover:bg-red-50 h-7 w-7 flex items-center justify-center rounded-md">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true" data-slot="icon" class="size-4">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12"></path>
            </svg>
          </button>
        </div>
      `
      this.listTarget.appendChild(wrapper)
      this.index++
    }

    // Reset fields
    this.addOnSelectTarget.selectedIndex = 0
    this.addOnQuantityTarget.value = 1
  }
}
