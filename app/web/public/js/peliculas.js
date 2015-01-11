/**
 * Created by jdph on 18/11/14.
 */
window.onload = start

function start() {
    comprobar_localstorage();
    pedir_peliculas();
}

function comprobar_localstorage() {
    if(localStorage.getItem("login")!=null) {
        document.getElementById("login").style.display = 'none'
        document.getElementById("password").style.display = 'none'
        document.getElementById("btn-login").style.display = 'none'
        document.getElementById("username").style.display = 'block'
        document.getElementById("username").value = document.getElementById("login").value
        document.getElementById("btn-logout").style.display = 'block'
    }
}

function pedir_peliculas() {
    var xhr = new XMLHttpRequest()
    xhr.open("GET", "/api/peliculas", true)
    xhr.onreadystatechange = callback_peliculas
    xhr.send()
}

function callback_peliculas() {
    if (this.readyState==4) {
        if(this.status==200) {
            var peliculas = JSON.parse(this.responseText)
            mostrar_peliculas(peliculas)
        }
    }
}

function mostrar_peliculas(peliculas) {
    var div_peliculas = document.getElementById("peliculas")
    var plantilla = document.getElementById("peliculas_tmpl").innerHTML // truco para no tener toda la plantilla aqui
    div_peliculas.insertAdjacentHTML("beforeend", Mustache.render(plantilla, peliculas))
}