import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.frame = document.getElementById("dashboard_edit_frame");
    this.element.addEventListener('turbo:submit-end', (e) => {
      console.log(e)
      this.frame.src = '/app/dashboard/edit';
    })
  }
  onTypeUpdated(e) {
    const form = new FormData();
    form.append('authenticity_token', this.element.dataset.authenticityToken);
    form.append('module[type]', e.target.value);
    fetch(`/layouts/${this.element.dataset.layoutId}/${this.element.dataset.contentsIndex}`, {
      method: 'PATCH',
      body: form,
    }).then(() => this.frame.src = '/app/dashboard/edit');
  }
}

