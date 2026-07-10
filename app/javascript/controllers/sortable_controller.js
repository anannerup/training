import { Controller } from "@hotwired/stimulus"

// Reorders sibling .list-row elements by dragging a handle, using Pointer
// Events (not the HTML5 Drag and Drop API) so it works with touch as well as
// a mouse. Persists the new order with a plain fetch — the one spot in this
// app where a bit of JS is unavoidable, since reordering-by-drag has no
// server-rendered equivalent.
export default class extends Controller {
  static targets = [ "item" ]
  static values = { url: String }

  start(event) {
    this.item = event.currentTarget.closest("[data-sortable-target='item']")
    this.item.setPointerCapture(event.pointerId)
    this.item.classList.add("dragging")
    event.preventDefault()
  }

  move(event) {
    if (!this.item) return
    event.preventDefault()

    const after = this.itemTargets
      .filter((item) => item !== this.item)
      .find((item) => event.clientY < item.getBoundingClientRect().top + item.getBoundingClientRect().height / 2)

    if (after) {
      this.item.parentNode.insertBefore(this.item, after)
    } else {
      this.item.parentNode.appendChild(this.item)
    }
  }

  end(event) {
    if (!this.item) return
    this.item.classList.remove("dragging")
    this.item = null
    this.persist()
  }

  persist() {
    const ids = this.itemTargets.map((item) => item.dataset.id)

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "application/json"
      },
      body: JSON.stringify({ ids })
    })
  }
}
