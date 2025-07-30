import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  onCellUpdate(event) {
    const form = new FormData();
    form.append('authenticity_token', this.element.dataset.authenticityToken);
    form.append('column', event.target.dataset.column);
    form.append('value', event.target.value);
    fetch(`/databases/${this.element.dataset.databaseId}/${event.target.dataset.row}`, {
      method: 'PATCH',
      body: form
    });
  }
}
