import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "template", "rowContainer"]

  add(event) {
    event.preventDefault();
    this.addRow();
  }

  addRow() {
    const newRow = this.newRow();
    this.rowContainerTarget.insertAdjacentHTML('beforeend', newRow)
    // Returns the id of the new row
    return newRow.match(/id="(.+?)"/)[1]
    
  }

  get maxIndex() {
    return Math.max(-1, ...this.rowTargets.map((row) => parseInt(row.dataset.index))) + 1
  }

  newRow() {
    return this.templateTarget.innerHTML.replace(/NEW_RECORD/g, this.maxIndex + 1)
  }
}
