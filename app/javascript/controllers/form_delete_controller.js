import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  delete(event) {
    event.preventDefault();
    this.element.remove();
  }
}
