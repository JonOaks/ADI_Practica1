/**
 * Created by jdph on 18/11/14.
 */
window.onload = start // ¡APAÑO! (lo hago de esta forma para poder ejecutar dos funciones al cargar la página)

function start() {
    comprobar_localstorage(); // compruebo si ya se ha inciado sesión para modificar la web dinámicamente
    pedir_informacion();
}

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

function pedir_informacion() {
    var xhr = new XMLHttpRequest()
    xhr.open("GET", "/api/peliculas/" + getUrlVars()['id'], true)
    xhr.onreadystatechange = callback_informacion
    xhr.send()
}

function callback_informacion() {
    if (this.readyState==4) {
        if (this.status == 200) {
            var pelicula = JSON.parse(this.responseText)
            mostrar_informacion(pelicula)
        }
    }
}

function mostrar_informacion(pelicula) {
    var div_titulo = document.getElementById("titulo")
    var div_pelicula = document.getElementById("pelicula")
    var plantilla_titulo = document.getElementById("titulo_tmpl").innerHTML
    var plantilla = document.getElementById("pelicula_tmpl").innerHTML
    div_titulo.insertAdjacentHTML("beforeend", Mustache.render(plantilla_titulo, pelicula))
    div_pelicula.insertAdjacentHTML("beforeend", Mustache.render(plantilla, pelicula))
}