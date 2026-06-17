const menuToggle = document.getElementById('menuToggle');
const topNav = document.getElementById('topNav');

menuToggle.addEventListener('click', () => {
  topNav.classList.toggle('show');
});
