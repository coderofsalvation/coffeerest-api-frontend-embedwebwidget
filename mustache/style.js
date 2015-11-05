(function (window, document) {
//  var loader = function () {
    var element = document.createElement("link");
    element.setAttribute("rel", "stylesheet");
    element.setAttribute("type", "text/css");
    element.setAttribute("href", "{{{url}}}");
    document.getElementsByTagName("head")[0].appendChild(element);
//  }; window.addEventListener ? window.addEventListener("load", loader, false) : window.attachEvent("onload", loader);
})(window, document);
