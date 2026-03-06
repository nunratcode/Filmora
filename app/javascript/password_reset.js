document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("password-reset-form");
  if (!form) return;

  const emailInput = form.querySelector(".email_box");
  const button = document.getElementById("reset-button");

  form.addEventListener("submit", async (event) => {
    event.preventDefault();

    const email = emailInput.value;
    try {
      const response = await fetch(form.action, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
        },
        body: JSON.stringify({ email: email })
      });

      const data = await response.json();

      if (response.ok) {
        // Новый пароль отправлен
        emailInput.value = data.message;
        emailInput.style.color = "#02B422";          
        emailInput.style.backgroundColor = "#49CB6030"; 
        emailInput.style.borderColor = "#49CB6030"; 
        emailInput.disabled = true;

        button.value = "Вернуться ко входу";
        button.onclick = () => window.location.href = "/signin";
      } else {
        // Пользователь не найден
        emailInput.value = data.message;
        emailInput.style.color = "#FF3F3F";          
        emailInput.style.backgroundColor = "#FF3F3F30"; 
        emailInput.style.borderColor = "#FF3F3F30"; 
        emailInput.disabled = false;

        button.value = "Попробовать снова";
        button.onclick = () => window.location.reload();
      }

    } catch (error) {
      console.error("Ошибка запроса:", error);
    }
  });
});