import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static classes = ['active']
  static targets = ["btn", "tab"]
  static values = {defaultTab: String}

  connect() {
    // Hide all tabs using Tailwind class
    this.tabTargets.forEach(tab => tab.classList.add("hidden"));
  
    // Show default tab
    const selectedTab = this.tabTargets.find(tab => tab.id === this.defaultTabValue);
    if (selectedTab) selectedTab.classList.remove("hidden");
  
    // Activate the corresponding button
    const selectedBtn = this.btnTargets.find(btn => btn.id === this.defaultTabValue);
    if (selectedBtn) selectedBtn.classList.add(...this.activeClasses);
  }

  // switch between tabs
  // add to your buttons: data-action="click->tabs#select"
  select(event) {
    // find tab matching (with same id as) the clicked btn
    const selectedTabId = event.currentTarget.id;
  
    this.tabTargets.forEach(tab => {
      // hide everything
      if (tab.id === selectedTabId) {
        tab.classList.remove("hidden");
      } else {
        tab.classList.add("hidden");
      }
    });

    // then show selected
    this.btnTargets.forEach(btn => {
      if (btn.id === selectedTabId) {
        btn.classList.add(...this.activeClasses);
      } else {
        btn.classList.remove(...this.activeClasses);
      }
    });
  }
}
