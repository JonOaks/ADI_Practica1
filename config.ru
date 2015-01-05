require 'rubygems'
require 'bundler'

#para que cuando se ejecute encuentre las rutas relativas a la raíz del proyecto
$LOAD_PATH << File.expand_path(__dir__)


require 'app/api/peliculas_api'
require 'app/api/autentificacion_api'
require 'app/web/servidor_web'

use Rack::Session::Pool

map '/api/peliculas' do
  run PeliculasAPI
end

map '/api/autentificacion' do
  run AutentificacionAPI
end

map '/web' do
  run ServidorWeb
end