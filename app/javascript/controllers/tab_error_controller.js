import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() { 
    if(!this.element.querySelector('.is-invalid')) return;

    const btnEl = document.querySelector(`[data-bs-target="#${this.element.id}"]`);
    if(!btnEl) return;
    btnEl.classList.add('is-invalid');    
  }
}
