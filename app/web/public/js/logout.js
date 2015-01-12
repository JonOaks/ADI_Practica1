document.getElementById("btn-logout").onclick = logout

function logout() {
    var xhr = new XMLHttpRequest()
    xhr.open("GET", "/api/autentificacion/logout", true)
    xhr.onreadystatechange = operaciones_logout
    xhr.send()
}

function operaciones_logout() {
    localStorage.removeItem("login");
    document.getElementById("login").style.display = 'block'
    document.getElementById("login").style.display = 'inline'
    document.getElementById("login").value = ""
    document.getElementById("password").style.display = 'block'
    document.getElementById("password").style.display = 'inline'
    document.getElementById("password").value = ""
    document.getElementById("btn-login").style.display = 'block'
    document.getElementById("btn-login").style.display = 'inline'
    document.getElementById("username").style.display = 'none'
    document.getElementById("btn-logout").style.display = 'none'
    //document.getElementById("btn-nueva").style.display = 'none'
}