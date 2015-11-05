(function (window, document) {
  var loader = function () {
    var script = document.createElement("script"), tag = document.getElementsByTagName("script")[0];
    script.src = "{{{url}}}"; tag.parentNode.insertBefore(script, tag);
  }; window.addEventListener ? window.addEventListener("load", loader, false) : window.attachEvent("onload", loader);
})(window, document);
