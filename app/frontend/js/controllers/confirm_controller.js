// app/javascript/controllers/confirm_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  show(event) {
    event.preventDefault();

    if (confirm(event.currentTarget.dataset.confirm)) {
      // If it was a form submission
      if (event.currentTarget.form) {
        event.currentTarget.form.requestSubmit();
      }
      // If it was a link
      else if (event.currentTarget.tagName === "A") {
        window.location.href = event.currentTarget.href;
      }
    }
  }
}
