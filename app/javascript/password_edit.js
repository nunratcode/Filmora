document.addEventListener("DOMContentLoaded", () => {
  const passwordInput = document.querySelector(".field");

  if (passwordInput) {
    passwordInput.addEventListener("input", () => {
      passwordInput.classList.toggle("filled", passwordInput.value.trim() !== "");
    });
  }
});