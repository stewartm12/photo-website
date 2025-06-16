import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="store"
export default class extends Controller {
  static targets = ["name", "slug"]

  generateSlug() {
    const name = this.nameTarget.value
    const slug = name
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '')

    this.slugTarget.value = slug
  }
}
