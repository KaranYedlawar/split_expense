document.addEventListener("turbolinks:load", () => {
  const modal = document.getElementById("expenseModal");
  if (!modal) return;

  const itemsContainer = modal.querySelector("#items-container");
  const addItemBtn = modal.querySelector("#add-item-btn");
  const itemTemplate = modal.querySelector("#item-template");

  if (!itemsContainer || !addItemBtn || !itemTemplate) return;

  addItemBtn.addEventListener("click", () => {
    const newItemHtml = itemTemplate.innerHTML.replace(
      /NEW_RECORD/g,
      new Date().getTime()
    );
    itemsContainer.insertAdjacentHTML("beforeend", newItemHtml);
  });

  itemsContainer.addEventListener("click", (e) => {
    if (e.target.classList.contains("remove-item-btn")) {
      e.target.closest(".item-fields").remove();
    }
  });
});
