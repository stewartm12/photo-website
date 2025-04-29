import { Controller } from "@hotwired/stimulus"
import debounce from "debounce"

// Connects to data-controller="submit"
export default class extends Controller {
  initialize() {
    this.submit = debounce(this.submit.bind(this), 600);
  };

  submit() {
    console.log("submit");
    this.element.requestSubmit();
  };
};
