var menuIcon = document.querySelector("#menu");
var sidebar = document.querySelector(".sidebar");
var container = document.querySelector(".videos-container");

menuIcon.onclick = function(){
    sidebar.classList.toggle("small-sidebar");
    container.classList.toggle("large-container");
}