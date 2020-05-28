require("@rails/ujs").start();
require("turbolinks").start();
import "jquery";
import "popper.js";
import "bootstrap";
import "src/song-chords";
import "src/tooltips";
import "src/broken-link-report";

$(document).on("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
});
