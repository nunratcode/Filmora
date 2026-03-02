document.addEventListener('turbo:load', () => {
  const emailInput = document.querySelector('.email_box');
  const passwordInput = document.querySelector('.password_box');

  if (emailInput) {
    emailInput.addEventListener('input', () => {
      emailInput.classList.toggle(
        'filled',
        emailInput.value.trim() !== ''
      );
    });
  }

  if (passwordInput) {
    passwordInput.addEventListener('input', () => {
      passwordInput.classList.toggle(
        'filled',
        passwordInput.value.trim() !== ''
      );
    });
  }
});