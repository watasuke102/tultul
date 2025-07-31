import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.src = `/app/database/${this.element.dataset.databaseId}`;
  }
  fetch_with_reload(url, method, body) {
    fetch(url, {method, body}).then(() => this.element.reload());
  }
  onSchemeUpdate(event) {
    const form = new FormData();
    form.append('authenticity_token', this.element.dataset.authenticityToken);
    form.append('before', event.target.dataset.column);
    form.append('after', event.target.value);
    this.fetch_with_reload(`/databases/${this.element.dataset.databaseId}/scheme/name`, 'PATCH', form);
  }
  onCellUpdate(event) {
    const form = new FormData();
    form.append('authenticity_token', this.element.dataset.authenticityToken);
    form.append('column', event.target.dataset.column);
    form.append('value', event.target.value);
    this.fetch_with_reload(`/databases/${this.element.dataset.databaseId}/${event.target.dataset.row}`, 'PATCH', form);
  }
  onDeleteButtonClicked(event) {
    if (!window.confirm("削除したデータは復元できません。\nこのデータを削除してもよろしいですか？")) {
      return;
    }
    const form = new FormData();
    form.append('authenticity_token', this.element.dataset.authenticityToken);
    this.fetch_with_reload(`/databases/${this.element.dataset.databaseId}/${event.currentTarget.dataset.row}`, 'DELETE', form);
  }
}
