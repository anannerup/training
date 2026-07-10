import { Turbo } from "@hotwired/turbo-rails"

// Replaces the browser's native confirm() alert for every data-turbo-confirm
// button across the app with the styled <dialog> in the layout. The dialog
// is looked up fresh on each call (not cached at import time) since Turbo
// Drive replaces the <body> — including the dialog — on every navigation.
Turbo.config.forms.confirm = (message) => {
  const dialog = document.getElementById("turbo-confirm-dialog")
  if (!dialog) return window.confirm(message)

  dialog.querySelector("#turbo-confirm-message").textContent = message
  dialog.showModal()

  return new Promise((resolve) => {
    dialog.addEventListener("close", () => resolve(dialog.returnValue === "confirm"), { once: true })
  })
}
