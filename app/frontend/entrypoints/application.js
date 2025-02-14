import "@fortawesome/fontawesome-pro/css/all.min.css";
import "@popperjs/core";
import * as bootstrap from "bootstrap";
import "~/js/chord-forms";
import "~/js/song-chords";

const tooltipTriggerList = document.querySelectorAll(
  '[data-bs-toggle="tooltip"]'
);
const tooltipList = [...tooltipTriggerList].map(
  (tooltipTriggerEl) => new bootstrap.Tooltip(tooltipTriggerEl)
);
