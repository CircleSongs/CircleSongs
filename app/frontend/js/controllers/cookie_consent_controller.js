import { Controller } from "@hotwired/stimulus";

const STORAGE_KEY = "cookie_consent";

export default class extends Controller {
  static targets = ["banner"];

  connect() {
    const consent = localStorage.getItem(STORAGE_KEY);
    if (consent) {
      this.bannerTarget.hidden = true;
      if (consent === "accepted") this.loadAnalytics();
    } else {
      this.bannerTarget.hidden = false;
    }
  }

  accept() {
    localStorage.setItem(STORAGE_KEY, "accepted");
    this.hideBanner();
    this.loadAnalytics();
  }

  decline() {
    localStorage.setItem(STORAGE_KEY, "declined");
    this.hideBanner();
  }

  hideBanner() {
    this.bannerTarget.hidden = true;
    document.body.focus();
  }

  loadAnalytics() {
    if (window.gtag || document.querySelector('script[src*="googletagmanager"]'))
      return;

    const script = document.createElement("script");
    script.async = true;
    script.src =
      "https://www.googletagmanager.com/gtag/js?id=UA-134757294-1";
    document.head.appendChild(script);

    window.dataLayer = window.dataLayer || [];
    window.gtag = function () {
      window.dataLayer.push(arguments);
    };
    window.gtag("js", new Date());
    window.gtag("config", "UA-134757294-1");
  }
}
