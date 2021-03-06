require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sinatra/activerecord'

require 'app/dominio/usuario'
require 'app/aplicacion/usuario_bo'

class AutentificacionAPI < Sinatra::Base

  configure do
    puts 'configurando API de autentificacion...'
    @@usuario_bo = UsuarioBO.new
  end

  configure :development do
    register Sinatra::Reloader
  end


  get '/hola' do
    puts 'se ha llamado a /hola'
    puts session.inspect
    'hola'
  end

  post '/login' do
    begin
      datos = JSON.parse(request.body.read)
      if datos['login'] && datos['password']
        usuario = @@usuario_bo.do_login(datos['login'], datos['password'])
        if usuario.nil?
          status 401
          'Login y/o password incorrectos'
        else
          # tengo un problema, las sesiones son diferentes a la hora
          # de autentificarse respecto a la aplicación de las películas
          session[:usuario] = usuario.login
          puts session.inspect
          status 200
          'Login OK'
        end
      else
        status 400
        'Falta el login y/o password'
      end
    rescue JSON::ParserError
      status 400
      'JSON incorrecto'
    end
  end

  get '/logout' do
    session[:usuario] = nil
  end


end