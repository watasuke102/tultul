import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.getElementById('database_select')?.addEventListener('change', (event) => {
      Turbo.visit('/app/database/' + event.target.value);
    })
  }
}
