require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require 'sinatra/activerecord'

require 'app/dominio/pelicula'
require 'app/aplicacion/critica_bo'
require 'app/aplicacion/pelicula_BO'
require 'app/util/validacion_error'


class PeliculasAPI < Sinatra::Base
  configure do
    puts 'configurando API de peliculas...'
    @@pelicula_bo = PeliculaBO.new
    @@critica_bo = CriticaBO.new
  end

  configure :development do
    register Sinatra::Reloader
  end

#----PELICULAS----
  # las excepciones del tipo "no existe la película/crítica con id x" lanzadas por la base de datos,
  # las gestionamos desde el controlador mediante una sencilla comprobación

  get '/' do # obtener todas las películas existentes
    @@pelicula_bo.listar_peliculas().to_json(:include => :criticas)
  end

  get '/:id' do # detalles de una película
    if(Pelicula.exists?(params[:id]))
      @@pelicula_bo.obtener_pelicula(params[:id]).to_json(:include => :criticas)
    else
      status 404
    end
  end

  post '/titulo/buscar' do # buscar películas por título
    # obtengo el título a buscar directamente del cuerpo de la petición
    datos = request.body.read
    p = @@pelicula_bo.buscar_peliculas_titulo(datos).to_json(:include => :criticas)
  end

  post '/director/buscar' do # buscar películas por director
    # obtengo el director a buscar directamente del cuerpo de la petición
    datos = request.body.read
    p = @@pelicula_bo.buscar_peliculas_director(datos).to_json(:include => :criticas)
  end

  post '/actor/buscar' do # buscar películas por actor
    # obtengo el actor a buscar directamente del cuerpo de la petición
    datos = request.body.read
    p = @@pelicula_bo.buscar_peliculas_actor(datos).to_json(:include => :criticas)
  end

  put '/:id' do # actualizar información de una película
    datos = JSON.parse(request.body.read)

    # esto lo hago para falsear las sesiones por que tengo problemas de no persistencia
    # y no he sabido solucionarlos
    # lo he comentado para que pasen los tests (descomentar para probar aplicación)

    #session[:usuario] = 'launchpad'
    puts session.inspect
    login_actual = session[:usuario]
    if (login_actual.nil?) # solo se actualiza si existe la película y el usuario está autentificado
      halt 401
      'No estás autentificado'
    elsif(Pelicula.exists?(params[:id]))
      @@pelicula_bo.actualizar_pelicula(params[:id],datos)
      'actualizada'
    else
      status 404
      'no actualizada'
    end
  end

  delete '/:id' do # borrar una película
    # esto lo hago para falsear las sesiones por que tengo problemas de no persistencia
    # y no he sabido solucionarlos
    # lo he comentado para que pasen los tests (descomentar para probar aplicación)

    #session[:usuario] = 'launchpad'

    login_actual = session[:usuario]
    if (login_actual.nil?) # solo se borra si existe la película y el usuario está autentificado
      halt 401
      'No estás autentificado'
    elsif(Pelicula.exists?(params[:id]))
      @@pelicula_bo.borrar_pelicula(params[:id])
      'borrada'
    else
      status 404
      'no borrada'
    end
  end

  post '/' do # crear una película
    # esto lo hago para falsear las sesiones por que tengo problemas de no persistencia
    # y no he sabido solucionarlos
    # lo he comentado para que pasen los tests (descomentar para probar aplicación)

    #session[:usuario] = 'launchpad'
    puts env['rack.session']
    login_actual = session[:usuario]
    if (login_actual.nil?) # solo se crea si el usuario está autentificado
      halt 401
      'No estás autentificado'
    end
    begin
      datos = JSON.parse(request.body.read)
      p = @@pelicula_bo.crear_pelicula(datos, session[:usuario])
      status 200
      p.to_json
    rescue JSON::ParserError => e          # catch(Exception e)
      status 400
      "Error en el JSON: #{e}"
    end
  end

#----CRITICAS----

  get '/:id_pelicula/criticas' do # obtener la lista de todas las críticas de la película especificada
    if(Pelicula.exists?(params[:id_pelicula]))
      @@critica_bo.listar_criticas(params[:id_pelicula]).to_json()
    else
      status 404
    end
  end

  get '/:id_pelicula/criticas/:id_critica' do # detalles de una crítica de la película especificada
    if(Pelicula.exists?(params[:id_pelicula]) && Critica.exists?(params[:id_critica]))
      @@critica_bo.obtener_critica(params[:id_critica],params[:id_pelicula]).to_json()
    else
      status 404
    end
  end

  post '/:id/criticas' do # crear crítica asociada a la película especificada
    # esto lo hago para falsear las sesiones por que tengo problemas de no persistencia
    # y no he sabido solucionarlos.
    # lo he comentado para que pasen los tests (descomentar para probar aplicación)

    #session[:usuario] = 'launchpad'

    login_actual = session[:usuario]
    if(Pelicula.exists?(params[:id])) # solo se crea si existe la película y el usuario está autentificado
      if (login_actual.nil?)
        halt 401
        'No estás autentificado'
      end
      begin
        datos = JSON.parse(request.body.read)
        p = @@critica_bo.crear_critica(datos, session[:usuario],params[:id])
        status 200
        p.to_json
      rescue JSON::ParserError => e          # catch(Exception e)
        status 400
        "Error en el JSON: #{e}"
      end
    else
      status 404
    end
  end

#----COMENTARIOS----
# serían igual que las criticas, implementación en la siguiente iteración
end