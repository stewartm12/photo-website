import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="preview"
export default class extends Controller {
  static targets = ['preview', 'input', 'fallback']

  displayPreview() {
    let input = this.inputTarget;
    let preview = this.previewTarget;
    let fallback = this.hasFallbackTarget ? this.fallbackTarget : null;
    let file = input.files[0];
    let reader = new FileReader();

    reader.onload = function() {
      preview.src = reader.result;
      preview.classList.remove('hidden');
      if (fallback) fallback.classList.add('hidden');
    }

    if (file) {
      reader.readAsDataURL(file);
    } else {
      preview.src = "";
    }
  }
}
