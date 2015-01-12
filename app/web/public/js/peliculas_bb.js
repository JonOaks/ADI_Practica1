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

var PeliculaModel = Backbone.Model.extend({
})

var Peliculas = Backbone.Collection.extend({
    model: PeliculaModel,
    url: '/api/peliculas'
})

var PeliculaView = Backbone.View.extend({
    className: 'pelicula',
    // template de una película (debajo de todas las películas aparece un botón para borrarla y otro para añadir una nueva)
    template: Mustache.compile('<div id="pel_{{id}}"><b>{{titulo}}</b><br><b>Creador: </b>{{usuario_id}}<br><a href="detalles_bb.html?id={{id}}" target="_self">Más información</a><br><button type="button" class="btn-borrar btn btn-default">Borrar película</button><br><button type="button" class="btn-editar btn btn-default">Editar película</button><br><button id="btn-nueva" type="button" class="btn btn-default">Añadir película</button><br><br>'),
    render: function() {
        this.el.innerHTML = this.template(this.model.toJSON())
    },
    borrarPelicula: function() { // borrado de una película
        if(localStorage.getItem("login")!=null) {
            this.model.destroy()
            this.remove()
        }
        else {
            alert("Antes de borrar una película debes iniciar sesión")
        }
    },
    // No he hecho un formulario para editar una película con backbone (ahorrar tiempo).
    // Siempre que se pulsa el botón editar película se modifica el título de una película
    // y se cambiar por "CREADA" y nada más.
    editarPelicula: function() {
        if(localStorage.getItem("login")!=null) {
            this.model.set("titulo","EDITADO")
            this.model.save()
            this.render()
        }
        else {
            alert("Antes de editar una película debes iniciar sesión")
        }
    },
    events: {
        "click .btn-borrar" : 'borrarPelicula',
        "click .btn-editar" : 'editarPelicula'
    }
})

var PeliculasView = Backbone.View.extend({
    initialize: function() {
        this.collection = new Peliculas()
        _.bindAll(this, "renderPelicula")
        this.collection.fetch({reset:true})
        this.listenTo(this.collection, "reset", this.render)
    },
    el: "#peliculas",
    render: function() {
        this.collection.each(this.renderPelicula)
    },
    renderPelicula: function(modelo) {
        var peliculaView = new PeliculaView({model: modelo})
        peliculaView.render()
        this.el.appendChild(peliculaView.el)
    },
    altaPelicula: function() { // creación de una película
        if(localStorage.getItem("login")!=null) {
            var pelicula = new PeliculaModel();
            // Al igual que al editar, no he hecho un formulario para crear una película con backbone.
            // Siempre que se pulsa el botón añadir película se añade una película
            // de título "CREADA" y nada más. Por eso, en este caso,
            // me refiero a todos los botones con el mismo id.
            pelicula.set("titulo", "CREADA")
            this.collection.add(pelicula)
            pelicula.save(null, {
                success: function(pelicula, response){
                    alert('Película creada.');
                }
            })
            this.renderPelicula(pelicula)
            // recargo la página, no sería necesario ya que ya hemos renderizado la nueva vista
            // pero lo he hecho por mero interés educativo
            location.reload(true)
        }
        else {
            alert("Antes de añadir una película debes iniciar sesión")
        }
    },
    events: {
        "click #btn-nueva" : "altaPelicula"
    }
})

var pelisView;
window.onload = function() {
    pelisView = new PeliculasView()
}
console.log("Todo iniciado guay")

