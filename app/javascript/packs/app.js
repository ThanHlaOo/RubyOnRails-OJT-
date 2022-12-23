
import '../stylesheets/style.css';
window.onload = function () {

  const dropdown = document.querySelector("#dropdown-link")
  const dropdown_menu = document.querySelector("#dropdown-menu")
  const btn = document.querySelectorAll(".post-title");
  const deleteBtn = document.querySelectorAll(".delete-btn");
  const closeModal = document.querySelectorAll(".close");

  dropdown.addEventListener('click', function (e) {
    e.preventDefault();
    dropdown_menu.classList.toggle('show-menu');
  });
  deleteBtn.forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      const href = e.target.getAttribute('href');
      const delete_modal = document.querySelector(`#delete-modal_${href}`)
      e.preventDefault();
      delete_modal.style.display = "block";

    });
  });

  btn.forEach(function (postTitle) {
    postTitle.addEventListener('click', function (e) {
      const href = e.target.getAttribute('href');
      const detail_modal = document.querySelector(`#detail-modal_${href}`)
      e.preventDefault();
      detail_modal.style.display = "block";

    });
  });

  closeModal.forEach(function (close) {
    close.addEventListener('click', function (e) {
      e.preventDefault();
      const href = e.target.getAttribute('data-id');
      const detail_modal = document.querySelector(`#detail-modal_${href}`)
      const delete_modal = document.querySelector(`#delete-modal_${href}`)
      detail_modal.style.display = "none";
      delete_modal.style.display = "none";
    });
  });


};


window.onclick = function (event) {
  const modal = document.querySelectorAll(".myModal");
  if (event.target == modal) {
    modal.style.display = "none";
  }
};

