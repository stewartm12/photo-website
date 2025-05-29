import { Controller } from "@hotwired/stimulus"
import { put } from "@rails/request.js"
import Sortable from 'sortablejs'

// Connects to data-controller="sortable"
export default class extends Controller {
  static values = { url: String };

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 350,
      ghostClass: "bg-gray-200",
      onEnd: this.onEnd.bind(this),
      handle: "[data-sortable-handle]",
    });
  }

  disconnect() {
    this.sortable.destroy();
  }

  onEnd(event) {
    const { newIndex, item } = event;
    const id = item.dataset["sortableId"];
    const url = this.urlValue.replace(":id", id)
    put(url, {
      body: JSON.stringify({ position: newIndex })
    });
  }
}
