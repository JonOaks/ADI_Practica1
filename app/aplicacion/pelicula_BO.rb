require 'app/dominio/peliculagenero'
require 'app/dominio/genero'
require 'app/dominio/pelicula'
require 'app/dominio/usuario'
require 'app/util/validacion_error'

##Por ahora es un stub, lo que estamos implementando de verdad es la capa REST
class PeliculaBO
  def listar_peliculas
    Pelicula.order(:id)
  end

  def obtener_pelicula(id)
    Pelicula.find(id)
  end

  def crear_pelicula(datos, login)
    p = Pelicula.new(datos)
    u = Usuario.find_by_login(login)
    if u.nil?
      return nil
    elsif p.valid?
      p.usuario = u
      p.save()
      return p
    else
      raise ValidacionError.new(p.errors)
    end
  end

  # busco el texto en el título de las películas
  def buscar_peliculas_titulo(datos)
    Pelicula.where("titulo like '%#{datos}%'")
  end

  # busco el texto en el director de las películas
  def buscar_peliculas_director(datos)
    Pelicula.where("director like '%#{datos}%'")
  end

  # busco el texto en los actores de las películas
  def buscar_peliculas_actor(datos)
    Pelicula.where("reparto like '%#{datos}%'")
  end

  def actualizar_pelicula(id,datos)
    Pelicula.update(id, datos)
  end

  def borrar_pelicula(id)
    Pelicula.delete(id)
  end
end