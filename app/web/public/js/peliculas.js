/**
 * Created by jdph on 18/11/14.
 */
window.onload = pedir_peliculas

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