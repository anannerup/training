import { Controller } from "@hotwired/stimulus"

// Lets you build up a weight by tapping plate buttons instead of typing a
// number. The server renders the field's starting value (previous set this
// session, last time's weight, or the bar) — this controller just adds to
// whatever's currently in the field and can reset back to that start.
export default class extends Controller {
  static targets = [ "input" ]

  connect() {
    this.startingValue = this.inputTarget.value
  }

  add(event) {
    const current = parseFloat(this.inputTarget.value) || 0
    this.inputTarget.value = this.round(current + event.params.amount)
  }

  reset() {
    this.inputTarget.value = this.startingValue
  }

  round(value) {
    return Math.round(value * 100) / 100
  }
}
