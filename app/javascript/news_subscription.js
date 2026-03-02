document.addEventListener('turbo:load', () => {
  const emailInput = document.querySelector('.news .box');
  const checkbox = document.querySelector('.news #agree');
  const button = document.querySelector('.news .button');

  if (!emailInput || !checkbox || !button) return;

  // изменение цвета текста при вводе email
  emailInput.addEventListener('input', () => {
    emailInput.classList.toggle(
      'filled',
      emailInput.value.trim() !== ''
    );
  });

  // активация кнопки только при чекбоксе
  checkbox.addEventListener('change', () => {
    button.disabled = !checkbox.checked;
  });

  // клик по кнопке
  button.addEventListener('click', (e) => {
    e.preventDefault();

    if (!checkbox.checked) return;

    button.textContent = 'Вы подписаны на рассылку Filmora';
    button.disabled = true;
    button.classList.add('subscribed');
  });
});