window.onload = function(){ 
  //Fix the hidden element issue on some chrome browsers
  window.scroll(0,1);
  window.scroll(0,0);
  var links = document.getElementById('links');
  if(!links)
    return;
  
  links.onclick = function (event) {
    event = event || window.event;
    var target = event.target || event.srcElement,
      link = target.src ? target.parentNode : target,
      options = {index: link, event: event},
      links = this.getElementsByTagName('a');
    blueimp.Gallery(links, options);
  };
};
