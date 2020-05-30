require("@rails/ujs").start();
require("turbolinks").start();
import "jquery";
import "popper.js";
import "bootstrap";
import "src/song-chords";
import "src/broken-link-report";
import "src/chord-forms";

$(document).on("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
});
