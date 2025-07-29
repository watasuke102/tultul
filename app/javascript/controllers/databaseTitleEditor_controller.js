import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["titleInput", "submitButton"]

  onTitleInputUpdate() {
    if (this.titleInputTarget.value === this.titleInputTarget.dataset.initial) {
      this.submitButtonTarget.disabled = true;
      this.submitButtonTarget.style = "display: none;";
    } else {
      this.submitButtonTarget.disabled = false;
      this.submitButtonTarget.style = "";
    }
  }
}
