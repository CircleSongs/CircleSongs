import "@activeadmin/activeadmin";
import "@fortawesome/fontawesome-free/css/all.min.css"
import "~/js/chord-forms";
import "~/js/song-chords";
import TomSelect from "tom-select";
import Sortable from "sortablejs";

// Initialize Tom Select on page load and after has_many additions
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
        maxOptions: 500,
      });
      select.classList.add("tom-select-initialized");
    });
}

// CSRF token helper for fetch requests
function csrfToken() {
  const meta = document.querySelector('meta[name="csrf-token"]');
  return meta ? meta.getAttribute("content") : "";
}

// Sortable admin index tables
document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll("table.data-table").forEach(function(table) {
    const tbody = table.querySelector("tbody");
    if (!tbody || !table.querySelector(".handle")) return;

    new Sortable(tbody, {
      handle: ".handle",
      animation: 150,
      onEnd: function() {
        const ids = Array.from(tbody.querySelectorAll("tr")).map(function(row) {
          return row.id.replace(/^[^_]+_/, "");
        });

        const body = ids.map(id => `ids[]=${encodeURIComponent(id)}`).join("&");
        fetch(window.location.pathname + "/sort", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRF-Token": csrfToken(),
          },
          body: body,
        });
      },
    });
  });
});

// Sortable has_many fields (AA4 removed jQuery UI sortable support)
document.addEventListener("DOMContentLoaded", initHasManySortables);
document.addEventListener("has_many_add:after", initHasManySortables);

function initHasManySortables() {
  document.querySelectorAll(".has-many-container[data-sortable]").forEach(function(container) {
    if (container.dataset.sortableInitialized) return;
    container.dataset.sortableInitialized = "true";

    const sortableColumn = container.dataset.sortable;
    const sortableStart = parseInt(container.dataset.sortableStart || "0", 10);

    // Add drag handles to each fieldset that doesn't already have one
    container.querySelectorAll("fieldset.has-many-fields").forEach(function(fieldset) {
      if (!fieldset.querySelector(".has-many-handle")) {
        const handle = document.createElement("span");
        handle.className = "has-many-handle";
        handle.textContent = "☰";
        handle.style.cursor = "grab";
        handle.style.marginRight = "0.5rem";
        handle.style.fontSize = "1.2em";
        fieldset.prepend(handle);
      }
    });

    new Sortable(container, {
      handle: ".has-many-handle",
      animation: 150,
      draggable: "fieldset.has-many-fields",
      onEnd: function() {
        // Update hidden position inputs after reorder
        container.querySelectorAll("fieldset.has-many-fields").forEach(function(fieldset, index) {
          const positionInput = fieldset.querySelector("input[id$='_" + sortableColumn + "']");
          if (positionInput) {
            positionInput.value = sortableStart + index;
          }
        });
      },
    });
  });
}
