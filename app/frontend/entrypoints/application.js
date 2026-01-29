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
    const icon = document.querySelector("[data-theme-icon]");
    if (!toggle) return;

    const apply = (theme) => {
      document.body.classList.toggle("theme-light", theme === "light");
      document.body.classList.toggle("theme-dark", theme !== "light");
      localStorage.setItem("msn-theme", theme);
    };

    const saved = localStorage.getItem("msn-theme");
    if (saved) apply(saved);

    toggle.addEventListener("click", () => {
      const isLight = document.body.classList.contains("theme-light");
      apply(isLight ? "dark" : "light");
    });
  } catch (error) {
    console.error('Theme toggle error:', error);
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