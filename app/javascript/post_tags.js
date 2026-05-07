function initTagsPopup() {
  const openBtn = document.getElementById("openTags");
  const popup = document.getElementById("tagsPopup");
  const saveBtn = document.getElementById("saveTags");
  const selectedContainer = document.getElementById("selectedTags");

  if (!openBtn || !popup || !saveBtn || !selectedContainer) return;

  let selected = [];

  openBtn.addEventListener("click", () => {
    popup.classList.remove("hidden");
  });

  document.querySelectorAll(".tag_option").forEach(tag => {
    tag.addEventListener("click", () => {
      const id = tag.dataset.id;

      if (selected.includes(id)) {
        selected = selected.filter(t => t !== id);
        tag.classList.remove("active");
      } else {
        selected.push(id);
        tag.classList.add("active");
      }
    });
  });

  saveBtn.addEventListener("click", () => {
    popup.classList.add("hidden");

    selectedContainer.innerHTML = "";

    selected.forEach(id => {
      const tagEl = document.querySelector(`[data-id='${id}']`);

      if (!tagEl) return;

      const tagName = tagEl.textContent;

      const span = document.createElement("span");
      span.textContent = `#${tagName}`;
      selectedContainer.appendChild(span);

      const input = document.createElement("input");
      input.type = "hidden";
      input.name = "post[tag_ids][]";
      input.value = id;

      selectedContainer.appendChild(input);
    });
  });
}

document.addEventListener("DOMContentLoaded", initTagsPopup);
document.addEventListener("turbo:load", initTagsPopup);