/**
 * Created by jdph on 18/11/14.
 */
window.onload = pedir_informacion

function getUrlVars() {
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