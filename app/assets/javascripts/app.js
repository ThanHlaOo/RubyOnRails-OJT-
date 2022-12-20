

window.onload = function () {
    const delete_modal = document.querySelector("#delete-modal");
    const detail_modal = document.querySelector("#detail-modal")
    const btn = document.querySelector("#post-title");  
    const closeModal = document.querySelector("#close");
    btn.onclick = function (e) {
      e.preventDefault();
      alert('hi')
    detail_modal.style.display = "block";
      console.log("clicked")
    };
    
    closeModal.onclick = function (e) {
        // e.preventDefault();
        detail_modal.style.display = "none";
      delete_modal.style.display = "none";
    };
 
  };


window.onclick = function (event) {
  const modal = document.querySelector(".myModal");
    if (event.target == modal) {
      modal.style.display = "none";
    }
  };

