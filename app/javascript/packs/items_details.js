function hideDetails() {
  let details = document.querySelectorAll(".details-displayed");
  details.forEach(function(detail){
    detail.style.display = "none"; // hide details
    detail.classList.remove("open"); // remove 'open' class
  });
}

function addEventOnDetailsButton() {
  let detailsButtons = document.querySelectorAll(".details");
  for(let i = 0; i < detailsButtons.length; i++) {
    detailsButtons[i].addEventListener("click", function(e) {
      if (e.target.classList.contains("open")) { // details are displayed
        e.target.classList.remove("open"); // remove 'open' class
        hideDetails(); // hide all displayed details
      } else {
        hideDetails(); // hide all displayed details
        e.target.classList.add("open"); // add 'open' class
        e.target.parentElement.querySelectorAll(".details-displayed").forEach(function(details){
          details.style.display = ""; // display details of this item
        });
      }
    });
  };
}

export { hideDetails };
export { addEventOnDetailsButton };
