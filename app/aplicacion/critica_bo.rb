require 'app/dominio/critica'
require 'app/dominio/pelicula'
require 'app/dominio/usuario'
require 'app/util/validacion_error'

class CriticaBO
  def listar_criticas(id_pelicula)
    Critica.where(pelicula_id:id_pelicula).order(:id)
  end

  def obtener_critica(id_critica,id_pelicula)
    Critica.where(id:id_critica,pelicula_id:id_pelicula)
  end

  def crear_critica(datos, login, pelicula)
    c = Critica.new(datos)
    u = Usuario.find_by_login(login)
    p = Pelicula.find(pelicula)
    if u.nil?
      return nil
    elsif p.nil?
      return nil
    elsif c.valid?
      c.usuario = u
      c.pelicula = p
      c.save()
      return c
    else
      raise ValidacionError.new(p.errors)
    end
  end
end