// === NAVBAR SCROLL EFFECT ===
window.addEventListener("scroll", () => {
  const navbar = document.getElementById("navbar");
  if (window.scrollY > 10) {
    navbar.classList.add(
      "bg-slate-950",
      "bg-opacity-80",
      "backdrop-blur",
      "shadow-md"
    );
  } else {
    navbar.classList.remove(
      "bg-slate-950",
      "bg-opacity-80",
      "backdrop-blur",
      "shadow-md"
    );
  }
});

// === MOBILE NAV TOGGLE ===
const btnNavbar = document.getElementById("btnNavbar");
const navMobile = document.getElementById("navMobile");
const burgerLine1 = document.getElementById("burgerLine1");
const burgerLine2 = document.getElementById("burgerLine2");
const burgerLine3 = document.getElementById("burgerLine3");

btnNavbar.addEventListener("click", () => {
  navMobile.classList.toggle("scale-0");
  burgerLine1.classList.toggle("rotate-45");
  burgerLine1.classList.toggle("translate-y-2");

  burgerLine2.classList.toggle("opacity-0");

  burgerLine3.classList.toggle("-rotate-45");
  burgerLine3.classList.toggle("-translate-y-2");
});

// === DARK MODE TOGGLE ===
const themeToggle = document.getElementById("themeToggle");
if (themeToggle) {
  themeToggle.addEventListener("click", () => {
    document.documentElement.classList.toggle("dark");
    // Optional: save preference
    const isDark = document.documentElement.classList.contains("dark");
    localStorage.setItem("theme", isDark ? "dark" : "light");
  });

  // Load theme from localStorage
  if (localStorage.getItem("theme") === "dark") {
    document.documentElement.classList.add("dark");
  }
}

// === AOS INIT ===
AOS.init({
  once: true,
});
