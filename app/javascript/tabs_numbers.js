document.addEventListener("DOMContentLoaded", () => {
    const tabs = document.querySelectorAll(".section_tab");
    const cards = document.querySelectorAll(".section_card");

    tabs.forEach(tab => {
        tab.addEventListener("click", () => {
            const target = tab.dataset.tab;

            tabs.forEach(t => t.classList.remove("active"));
            tab.classList.add("active");

            cards.forEach(card => {
                card.classList.toggle(
                    "active",
                    card.dataset.content === target
                );
            });
        });
    });
});