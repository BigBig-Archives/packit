let moreElts = document.querySelectorAll(".more-displayed");
moreElts.forEach(function(moreElt){
  moreElt.style.display = 'none';
})

let moreButtons = document.querySelectorAll(".more");
for(let i = 0; i < moreButtons.length; i++) {
  moreButtons[i].addEventListener('click', function(e){
    moreElts.forEach(function(moreElt){
      moreElt.style.display = 'none';            // close all elements
    });
    if (e.target.classList.contains('open')){    // ELEMENT IS OPEN
      e.target.classList.remove('open');         // remove 'open' class to this element
    } else {                                     // ELEMENT IS CLOSED
      moreButtons.forEach(function(moreButton){
        moreButton.classList.remove('open');     // remove 'open' class to all elements
      });
      e.target.classList.add('open');            // add 'open' class to this element
      e.target.parentElement.querySelectorAll(".more-displayed").forEach(function(moreElt){
        moreElt.style.display = '';              // display this element
      });
    }
  });
}
