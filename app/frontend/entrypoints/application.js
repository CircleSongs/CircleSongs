import { Application } from "@hotwired/stimulus";
import { registerControllers } from "stimulus-vite-helpers";

import "@fortawesome/fontawesome-free/css/all.min.css"
import "@popperjs/core";
import * as bootstrap from "bootstrap";

const application = Application.start();

// Register all controllers in the controllers directory
const controllers = import.meta.glob("/js/controllers/**/*_controller.js", {
  eager: true,
});
registerControllers(application, controllers);

import "~/js/chord-forms";
import "~/js/song-chords";

const tooltipTriggerList = document.querySelectorAll(
  '[data-bs-toggle="tooltip"]'
);
const tooltipList = [...tooltipTriggerList].map(
  (tooltipTriggerEl) => new bootstrap.Tooltip(tooltipTriggerEl)
);
