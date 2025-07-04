import { Controller } from "@hotwired/stimulus"
import { showFlash } from "helpers/inline_flash"

// Connects to data-controller="photo-selector"
export default class extends Controller {
  static targets = ["checkbox", "selectAll", "actionsBar", "selectedCount", "deleteBtn", "downloadBtn"];

  static values = {
    storeSlug: String,
    galleryId: Number,
    collectionId: Number,
    showcaseId: Number
  }

  connect() {
    this.updateActionsBar();
    this.element.addEventListener('turbo:submit-end', () => {
      this.clearSelections();
    });
  }

  downloadSelected() {
    const selectedIds = this.checkboxTargets
      .filter(box => box.checked)
      .map(box => box.value);
  
    if (selectedIds.length === 0) return;
  
    const params = new URLSearchParams();
    selectedIds.forEach(id => params.append('photo_ids[]', id));
  
    const url = `/${this.storeSlugValue}/galleries/${this.galleryIdValue}/collections/${this.collectionIdValue}/photos/download?${params.toString()}`;
  
    fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
    .then((response) => {
      if (response.ok) {
        this.clearSelections();
        showFlash("notice", "Download request submitted. The file will be ready in the Downloads tab within a few minutes.");
      } else {
        showFlash("alert", "Something went wrong while requesting the download.");
      }
    })
    .catch(() => {
      showFlash("alert", "Network error while sending download request.");
    });
  }

  handleDeleteClick(event) {
    this.element.requestSubmit();
  }

  clearSelections() {
    this.checkboxTargets.forEach(cb => cb.checked = false)
    this.selectAllTarget.checked = false
    this.actionsBarTarget.classList.add("hidden");
    this.actionsBarTarget.classList.remove("flex");
    this.selectedCountTarget.textContent = "0 photos selected"
    this.deleteBtnTarget.disabled = true
    if (this.hasDownloadBtn) this.downloadBtnTarget.disabled = true;
  }

  toggleSelectAll() {
    const checked = this.selectAllTarget.checked;
    this.checkboxTargets.forEach(box => box.checked = checked);
    this.updateActionsBar();
  }

  toggleCheckbox() {
    this.updateActionsBar();
  }

  updateActionsBar() {
    const checkedBoxes = this.checkboxTargets.filter(box => box.checked);
    const count = checkedBoxes.length;

    if (count > 0) {
      this.actionsBarTarget.classList.remove("hidden");
      this.actionsBarTarget.classList.add("flex");
    } else {
      this.actionsBarTarget.classList.add("hidden");
      this.actionsBarTarget.classList.remove("flex");
    }

    // Update selected count text
    this.selectedCountTarget.textContent = `${count} photo${count !== 1 ? 's' : ''} selected`;

    // Enable/disable buttons
    this.deleteBtnTarget.disabled = count === 0;
    if (this.hasDownloadBtn) this.downloadBtnTarget.disabled = count === 0;

    // Update select all checkbox state
    if (count === this.checkboxTargets.length) {
      this.selectAllTarget.checked = true;
      this.selectAllTarget.indeterminate = false;
    } else if (count === 0) {
      this.selectAllTarget.checked = false;
      this.selectAllTarget.indeterminate = false;
    } else {
      this.selectAllTarget.checked = false;
      this.selectAllTarget.indeterminate = true;
    }
  }
}
