/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


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
      e.preventDefault();
      const href = e.target.getAttribute('href').split("/")[2];
      const delete_modal = document.querySelector(`#delete-modal_${href}`)
      delete_modal.style.display = "block";

    });
  });

  btn.forEach(function (postTitle) {
    postTitle.addEventListener('click', function (e) {
      e.preventDefault();
      const href = e.target.getAttribute('href');
      const detail_modal = document.querySelector(`#detail-modal_${href}`)
      detail_modal.style.display = "block";

    });
  });

  closeModal.forEach(function (close) {
    close.addEventListener('click', function (e) {
      e.preventDefault();
      const href = e.target.getAttribute('data_id');
      const detail_modal = document.querySelector(`#detail-modal_${href}`)
      const delete_modal = document.querySelector(`#delete-modal_${href}`)
      console.log(detail_modal)
      console.log(delete_modal)
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

