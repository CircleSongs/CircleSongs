import $ from "jquery";
window.$ = $;
import "jquery-ui-dist/jquery-ui";
import "@fortawesome/fontawesome-free/css/all.min.css"
import "@activeadmin/activeadmin";
import Rails from "@rails/ujs";
Rails.start();
import "~/js/chord-forms";
import "~/js/song-chords";
import TomSelect from "tom-select";
import "tom-select/dist/css/tom-select.default.css";

// Initialize Tom Select on page load and after Turbo renders
document.addEventListener("DOMContentLoaded", initTomSelects);
document.addEventListener("has_many_add:after", initTomSelects);

function initTomSelects() {
  // Initialize regular tom-select
  document
    .querySelectorAll(".tom-select:not(.tom-select-initialized)")
    .forEach((select) => {
      new TomSelect(select, { maxOptions: 500 });
      select.classList.add("tom-select-initialized");
    });

  // Initialize tom-select with tagging support
  document
    .querySelectorAll(".tom-select-tags:not(.tom-select-initialized)")
    .forEach((select) => {
      new TomSelect(select, {
        create: true,
        plugins: ["remove_button"],
      });
      select.classList.add("tom-select-initialized");
    });
}

// Include CSRF token in all jQuery AJAX requests
$.ajaxSetup({
  headers: {
    "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
  }
});

// Sortable admin index tables
$(document).ready(function() {
  $("table.index_table:has(.handle) tbody").sortable({
    handle: ".handle",
    axis: "y",
    update: function() {
      var ids = $(this).find("tr").map(function() {
        return this.id.replace(/^[^_]+_/, "");
      }).get();
      $.post(window.location.pathname + "/sort", { ids: ids });
    }
  });
});
