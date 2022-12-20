

window.onload = function () {
    const modal = document.querySelector("#myModal");
    const btn = document.querySelector("#post-title");  
    const closeModal = document.querySelector("#close");
    btn.onclick = function (e) {
      e.preventDefault();
      alert('hi')
    modal.style.display = "block";

    };
    
    closeModal.onclick = function (e) {
        // e.preventDefault();
        modal.style.display = "none";
    };
 
  };


  window.onclick = function (event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  };

