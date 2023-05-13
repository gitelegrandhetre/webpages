function set_description(index, slide) {
  var text = this.list[index].getAttribute('data-description');
  var node = this.container.find('.description');
  node.empty()
  if (text)
    node[0].appendChild(document.createTextNode(text));
}

// Setup the gallery
(() => {
  'use strict'

  document.getElementById('gallery').onclick = function(event) {
    event = event || window.event;
    var target = event.target || event.srcElement;
    var link = target.src ? target.parentNode : target;
    var options = {
      index: link,
      event: event,
      onslide: set_description
    };
    var links = this.getElementsByTagName('a');
    blueimp.Gallery(links, options);
  }
})();

// Setup lightbox on individual photos
(() => {
  'use strict'

  function lightbox(event) {
    event = event || window.event;
    event.preventDefault();
    var target = event.target || event.srcElement;
    var link = target.src ? target.parentNode : target;
    var options = {
      index: link,
      event: event,
      onslide: set_description
    };
    blueimp.Gallery([this], options);
  }

  for (const el of document.getElementsByClassName("lightbox")) {
    el.onclick = lightbox;
  }
})();

// Form validation
(() => {
  'use strict'

  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  const forms = document.querySelectorAll('.needs-validation')

  // Loop over them and prevent submission
  Array.from(forms).forEach(form => {
    form.addEventListener('submit', event => {
      if (!form.checkValidity()) {
        event.preventDefault()
        event.stopPropagation()
      }

      form.classList.add('was-validated')
    }, false)
  })
})();
