document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector(".subscription_form");
  if (!form) return;

  const submitBtn = document.getElementById("subscription_button");

  form.addEventListener("ajax:success", () => {
    submitBtn.value = "Отправлено!";
    submitBtn.disabled = true;
  });

  form.addEventListener("ajax:error", () => {
    alert("Произошла ошибка. Попробуйте ещё раз.");
  });
});