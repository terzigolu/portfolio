(function () {
  "use strict";

  const STORAGE_KEY = "yt-theme";
  const root = document.documentElement;
  const body = document.body;
  const header = document.querySelector("#site-header");
  const navToggle = document.querySelector("#nav-toggle");
  const siteNav = document.querySelector("#site-nav");
  const themeToggle = document.querySelector("#theme-toggle");
  const themeIcon = document.querySelector("[data-theme-icon]");
  const navLinks = Array.from(document.querySelectorAll("[data-nav-link]"));
  const sections = Array.from(document.querySelectorAll("[data-section]"));
  const revealItems = Array.from(document.querySelectorAll("[data-reveal]"));
  const reduceMotionQuery = window.matchMedia("(prefers-reduced-motion: reduce)");
  const desktopQuery = window.matchMedia("(min-width: 769px)");

  const readStoredTheme = () => {
    try {
      return localStorage.getItem(STORAGE_KEY);
    } catch (error) {
      return null;
    }
  };

  const saveTheme = (theme) => {
    try {
      localStorage.setItem(STORAGE_KEY, theme);
    } catch (error) {
      // The selected theme still applies for this visit when storage is blocked.
    }
  };

  const getPreferredTheme = () => {
    const storedTheme = readStoredTheme();
    return storedTheme === "light" || storedTheme === "dark" ? storedTheme : "dark";
  };

  const updateThemeControl = (theme) => {
    if (!themeToggle) return;
    const nextTheme = theme === "dark" ? "light" : "dark";
    themeToggle.setAttribute("aria-label", "Toggle color theme");
    themeToggle.setAttribute("title", `Switch to ${nextTheme} theme`);
    themeToggle.setAttribute("aria-pressed", String(theme === "light"));
    if (themeIcon) themeIcon.textContent = theme === "dark" ? "☼" : "☾";
  };

  const applyTheme = (theme, persist = false) => {
    document.documentElement.dataset.theme = theme;
    updateThemeControl(theme);
    if (persist) saveTheme(theme);
  };

  const toggleTheme = () => {
    const currentTheme = root.dataset.theme === "light" ? "light" : "dark";
    const nextTheme = currentTheme === "dark" ? "light" : "dark";
    root.classList.add("theme-transition");
    applyTheme(nextTheme, true);
    window.setTimeout(() => root.classList.remove("theme-transition"), 260);
  };

  const setNavigationOpen = (open) => {
    if (!navToggle || !siteNav) return;
    body.classList.toggle("nav-open", open);
    navToggle.setAttribute("aria-expanded", String(open));
    navToggle.setAttribute("aria-label", open ? "Close navigation" : "Open navigation");
  };

  const updateHeader = () => {
    if (!header) return;
    header.classList.toggle("scrolled", window.scrollY > 20);
  };

  const revealEverything = () => {
    revealItems.forEach((item) => item.classList.add("is-visible"));
  };

  const initializeReveals = () => {
    if (reduceMotionQuery.matches || !("IntersectionObserver" in window)) {
      revealEverything();
      return;
    }

    const revealObserver = new IntersectionObserver(
      (entries, observer) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return;
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        });
      },
      { rootMargin: "0px 0px -9% 0px", threshold: 0.08 }
    );

    revealItems.forEach((item) => revealObserver.observe(item));
  };

  const initializeScrollspy = () => {
    if (!("IntersectionObserver" in window)) return;

    const sectionObserver = new IntersectionObserver(
      (entries) => {
        const visibleSection = entries
          .filter((entry) => entry.isIntersecting)
          .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];

        if (!visibleSection) return;
        const sectionId = visibleSection.target.id;
        navLinks.forEach((link) => {
          link.classList.toggle("active", link.getAttribute("href") === `#${sectionId}`);
        });
      },
      { rootMargin: "-28% 0px -58% 0px", threshold: [0, 0.15, 0.4] }
    );

    sections.forEach((section) => sectionObserver.observe(section));
  };

  applyTheme(getPreferredTheme());
  updateHeader();
  initializeReveals();
  initializeScrollspy();

  themeToggle?.addEventListener("click", toggleTheme);
  navToggle?.addEventListener("click", () => {
    const isOpen = navToggle.getAttribute("aria-expanded") === "true";
    setNavigationOpen(!isOpen);
  });

  navLinks.forEach((link) => {
    link.addEventListener("click", () => setNavigationOpen(false));
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") setNavigationOpen(false);
  });

  document.addEventListener("click", (event) => {
    if (!body.classList.contains("nav-open") || !siteNav || !navToggle) return;
    if (siteNav.contains(event.target) || navToggle.contains(event.target)) return;
    setNavigationOpen(false);
  });

  desktopQuery.addEventListener("change", (event) => {
    if (event.matches) setNavigationOpen(false);
  });

  reduceMotionQuery.addEventListener("change", (event) => {
    if (event.matches) revealEverything();
  });

  window.addEventListener("scroll", updateHeader, { passive: true });
})();
