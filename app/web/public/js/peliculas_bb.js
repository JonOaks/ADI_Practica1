/**
 * Created by jdph on 11/01/15.
 */
window.onload = comprobar_localstorage() // compruebo si ya se ha inciado sesión para modificar la web dinámicamente

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

var Pelicula = Backbone.Model.extend();
var Peliculas = Backbone.Collection.extend({
    url: '/api/peliculas',
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
            var template = _.template( $("#peliculas_tmpl").html(), peliculas);

            var myview = new Vista({ el: $("#peliculas") });
            myview.$el.html( template );
        }
    });
});