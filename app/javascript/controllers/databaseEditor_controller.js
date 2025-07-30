import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.src = `/app/database/${this.element.dataset.databaseId}`;
  }
  patch(url, body) {
    fetch(url, {method: 'PATCH', body}).then(() => this.element.reload());
  }
  onSchemeUpdate(event) {
    const form = new FormData();
    form.append('authenticity_token', this.element.dataset.authenticityToken);
    form.append('before', event.target.dataset.column);
    form.append('after', event.target.value);
    this.patch(`/databases/${this.element.dataset.databaseId}/scheme/name`, form);
  }
  onCellUpdate(event) {
    const form = new FormData();
    form.append('authenticity_token', this.element.dataset.authenticityToken);
    form.append('column', event.target.dataset.column);
    form.append('value', event.target.value);
    this.patch(`/databases/${this.element.dataset.databaseId}/${event.target.dataset.row}`, form);
  }
}
