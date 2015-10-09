Unfancy rest apis, frontend skeleton for third party web widget + embedcode

<img alt="" src="https://github.com/coderofsalvation/coffeerest-api/raw/master/coffeerest.png" width="20%" />

## Ouch! Is it that simple?

Just add these fields to your coffeerest-api `model.coffee` specification 

           module.exports = 
             host: "localhost:8080"
    --->     webwidget:
    --->       id: "yourproject"
    --->       transport: "http://"
    --->       urls:
    --->         js: "/embed/js"
    --->         test: "/embed/test"
    --->       app:
    --->         files:
    --->           js: [ __dirname+"/public/embed/ractive.min.js", __dirname+"/public/embed/app.js"]

## Usage 

    npm install coffeerest-api
    npm install coffeerest-api-doc
    npm install coffeerest-api-frontend-embedwebwidget

for servercode see [coffeerest-api](https://www.npmjs.com/package/coffeerest-api)

## Example

    $ coffee server.coffee &
    $ curl -H 'Content-Type: application/json' http://localhost:8080/v1/embed/test 

Your embedcode will look like this:

    <div id="plaatz"></div> 
    <script>
    (function (window, document) {
      var loader = function () {
        var id = "YOUR_USER_TOKEN_HERE";
        var script = document.createElement("script"), tag = document.getElementsByTagName("script")[0];
        script.src = "http://localhost:8080/v1/embed/js?id="+id; tag.parentNode.insertBefore(script, tag);
      }; window.addEventListener ? window.addEventListener("load", loader, false) : window.attachEvent("onload", loader);
    })(window, document);
    </script>

Voila, you have a wonderful startingpoint to build 3rd party webwidgets.
The `script.src`-url will return the concatenated string of all files defined in `webwidget.app.files.js`
