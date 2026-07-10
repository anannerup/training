import { Controller } from "@hotwired/stimulus"

// Reorders sibling rows via native HTML5 drag-and-drop, the same technique
// 37signals' Writebook uses for reordering pages — no Pointer Events, no
// manual position tracking. The browser renders the drag ghost and handles
// cursor tracking for free; we just move the real row into place whenever
// the browser tells us it's being dragged over another row. Note: this only
// fires from a touch gesture on iOS Safari 15+, not on Android — fine here
// since this list is only ever reordered from an iPhone.
export default class extends Controller {
  static targets = [ "item" ]
  static values = { url: String }

  dragStart(event) {
    this.dragging = event.currentTarget.closest("[data-sortable-target='item']")

    const rect = this.dragging.getBoundingClientRect()
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setDragImage(this.dragging, event.clientX - rect.left, event.clientY - rect.top)

    // Deferred a frame so the browser snapshots the drag image before we dim the source row.
    requestAnimationFrame(() => this.dragging.classList.add("dragging"))
  }

  dragOver(event) {
    event.preventDefault()
    if (!this.dragging) return

    const target = event.target.closest("[data-sortable-target='item']")
    if (!target || target === this.dragging) return

    const isBefore = this.itemTargets.indexOf(this.dragging) > this.itemTargets.indexOf(target)
    isBefore ? target.before(this.dragging) : target.after(this.dragging)
  }

  drop(event) {
    event.preventDefault()
  }

  dragEnd() {
    this.dragging?.classList.remove("dragging")
    this.dragging = null
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
