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

// Hamburger (992px collapse)
(function () {
  try {
    const header = document.querySelector("[data-header]");
    const btn = document.querySelector("[data-nav-toggle]");
    const panel = document.querySelector("[data-nav-panel]");
    if (!header || !btn || !panel) return;

    const closeMenu = () => {
      header.classList.remove("is-open");
      btn.setAttribute("aria-expanded", "false");
    };

    btn.addEventListener("click", () => {
      const isOpen = header.classList.toggle("is-open");
      btn.setAttribute("aria-expanded", String(isOpen));
    });

    document.addEventListener("click", (e) => {
      if (!header.classList.contains("is-open")) return;
      if (!header.contains(e.target)) closeMenu();
    });

    let resizeTimer;
    window.addEventListener("resize", () => {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(() => {
        if (window.matchMedia("(min-width: 992px)").matches) closeMenu();
      }, 250);
    });
  } catch (error) {
    console.error('Menu initialization error:', error);
  }
})();

// Theme toggle (dark/light)
(function () {
  try {
    const toggle = document.querySelector("[data-theme-toggle]");
    if (!toggle) return;

    toggle.addEventListener("click", () => {
      const isLight = document.body.classList.contains("theme-light");
      const newTheme = isLight ? "dark" : "light";
      
      fetch('/theme', {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({ theme: newTheme })
      }).then(() => {
        document.body.classList.toggle("theme-light", newTheme === "light");
        document.body.classList.toggle("theme-dark", newTheme === "dark");
      });
    });
  } catch (error) {
    console.error('Theme toggle error:', error);
  }
})();

// Smooth scroll to search results after form submission OR pagination
(function () {
  try {
    const searchForm = document.querySelector('form[action*="/songs"]');
    const resultsTable = document.querySelector('.songlist'); // adjust selector to match your table

    if (!searchForm || !resultsTable) return;

    // Check if we just performed a search (URL has query params) OR pagination
    const urlParams = new URLSearchParams(window.location.search);
    const hasSearchParams = Array.from(urlParams.keys()).some(key => key.startsWith('q['));
    const hasPageParam = urlParams.has('page');

    if (hasSearchParams || hasPageParam) {
      resultsTable.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  } catch (error) {
    console.error('Search scroll error:', error);
  }
})();

// Simple alert from bootstrap
(function () {
  try {
    document.addEventListener('click', (e) => {
      if (e.target.classList.contains('alert')) {
        e.target.remove();
      }
    });
  } catch (error) {
    console.error('Alert removal error:', error);
  }
})();

// Featured carousel (Swiper)
(function () {
  try {
    const el = document.querySelector("[data-featured-swiper]");
    if (!el) return;

    new Swiper(el, {
      loop: true,
      slidesPerView: 1,
      speed: 450,
      autoplay: { delay: 6500, disableOnInteraction: false },
      pagination: {
        el: document.querySelector(".swiper-pagination"),
        clickable: true
      }
    });
  } catch (error) {
    console.error('Swiper initialization error:', error);
  }
})();