window.onload = comprobar_localstorage()// compruebo si ya se ha inciado sesión para modificar la web dinámicamente

function comprobar_localstorage() {
    if(localStorage.getItem("login")!=null) {
        document.getElementById("login").style.display = 'none'
        document.getElementById("password").style.display = 'none'
        document.getElementById("btn-login").style.display = 'none'
        document.getElementById("username").style.display = 'block'
        document.getElementById("username").value = localStorage.getItem("login")
        document.getElementById("btn-logout").style.display = 'block'
    }
}

function getUrlVars() { // función que utilizo para obtener los parámetros de la url
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i=0; i<hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

var Pelicula = Backbone.Model.extend();
var Peliculas = Backbone.Collection.extend({
    url: "/api/peliculas/" + getUrlVars()['id'],
    model: Pelicula
});

var Vista = Backbone.View.extend({});

$(function(){
    var peliculas = new Peliculas();

    peliculas.fetch({
        success: function (data) {
            console.log("success con exito");
            var datos = new Array();
            for (var i = 0; i < data.models.length; i++) {
                datos.push(data.models[i].attributes);
            };
            var peliculas = { peliculas : datos }; console.log(peliculas);
            var template = _.template( $("#pelicula_tmpl").html(), peliculas);
            var template2 = _.template( $("#titulo_tmpl").html(), peliculas);

            var myview = new Vista({ el: $("#pelicula") });
            var myview2 = new Vista({ el: $("#titulo") });
            myview.$el.html( template );
            myview2.$el.html( template2 );
        }
    });
});
