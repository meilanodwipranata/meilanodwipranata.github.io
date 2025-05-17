window.addEventListener('scroll', function() {
  var navbar = document.getElementById('navbar');
  if (window.pageYOffset > 0) {
    navbar.classList.add("backdrop-filter", "backdrop-blur-sm", "shadow-lg", "bg-slate-950", "bg-opacity-70");
  } else {
    navbar.classList.remove("backdrop-filter", "backdrop-blur-sm", "shadow-lg", "bg-slate-950", "bg-opacity-70");
  }
});

const btnNavbar = document.getElementById("btnNavbar")

const burgerLine1 = document.getElementById("burgerLine1")
const burgerLine2 = document.getElementById("burgerLine2")
const burgerLine3 = document.getElementById("burgerLine3")

const navMobile = document.getElementById("navMobile")

const contactDiv = document.getElementById("contactDiv")
const contactDivOpacity = document.getElementById("contactDivOpacity")
const contactDivOpacityParent = document.getElementById("contactDivOpacityParent")
const envelopeLine1 = document.getElementById("envelopeLine1")
const envelopeLine2 = document.getElementById("envelopeLine2")

btnNavbar.addEventListener('click', function() {
  burgerLine1.classList.toggle('rotate-45');
  burgerLine1.classList.toggle('w-10');
  burgerLine1.classList.toggle('w-[36px]');
});
btnNavbar.addEventListener('click', function() {
  burgerLine2.classList.toggle('scale-0');
});
btnNavbar.addEventListener('click', function() {
  burgerLine3.classList.toggle('-rotate-45');
  burgerLine3.classList.toggle('w-10');
  burgerLine3.classList.toggle('w-[36px]');
});
btnNavbar.addEventListener('click', function() {
  navMobile.classList.toggle("scale-0")
});

contactDiv.addEventListener('click', function() {
  envelopeLine1.classList.add("scale-0"),
  envelopeLine2.classList.add("scale-0")
  contactDivOpacity.classList.add("translate-y-full")
  setTimeout(() => {
    contactDivOpacityParent.classList.remove('md:flex');
  }, 1000);
});