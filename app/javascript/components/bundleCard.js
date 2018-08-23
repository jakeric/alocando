function activeCard(item) {
  item.classList.add("bundle_selected");
};


const cardList = document.querySelectorAll('#background');
let i = 0
cardList.forEach(element => {
  element.classList.add(`card${i}`)
  let link = element.querySelector('#outline')
  link.addEventListener("click", activeCard(element))
});


