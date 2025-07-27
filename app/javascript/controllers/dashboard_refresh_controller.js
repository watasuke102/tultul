import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["frame"];

  connect() {
    this.refreshInterval = setInterval(() => {
      if (this.hasFrameTarget) {
        this.frameTarget.src = "/app/dashboard";
      }
    }, 1000 * 60);
  }

  disconnect() {
    clearInterval(this.refreshInterval);
  }
}
