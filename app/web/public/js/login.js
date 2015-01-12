document.getElementById("btn-login").onclick = login

function login() {
    var xhr = new XMLHttpRequest()
    xhr.open("POST", "/api/autentificacion/login", true)
    xhr.onreadystatechange = login_correcto
    xhr.setRequestHeader("Content-type", "application/json")
    var firma = {};
    firma.login = document.getElementById("login").value
    firma.password = document.getElementById("password").value
    xhr.send(JSON.stringify(firma))
}

function login_correcto() {
    if (this.status==200) {
        localStorage.setItem("login",document.getElementById("login").value);
        document.getElementById("login").style.display = 'none'
        document.getElementById("password").style.display = 'none'
        document.getElementById("btn-login").style.display = 'none'
        document.getElementById("username").style.display = 'block'
        document.getElementById("username").value = document.getElementById("login").value
        document.getElementById("btn-logout").style.display = 'block'
    }
    else {
        alert("Login y/o password incorrectos")
    }
}