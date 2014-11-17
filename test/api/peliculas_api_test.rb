require 'minitest/autorun'
require 'rack/test'
require 'mocha/mini_test'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/api/peliculas_api'

class PeliculasAPITest < MiniTest::Test
  include Rack::Test::Methods

  def app
    PeliculasAPI
  end

  def test_hola_2
    assert_equal 2, 1+1
  end

  def test_lista
    get '/'
    assert_equal last_response.status, 200
    datos = JSON.parse(last_response.body)
    assert_equal 2, datos.length
    assert_equal 'Harold y Maude',
                 datos[0]['titulo']
  end

  def test_crear_peli_sin_autentificar
    p = Pelicula.new
    p.titulo = 'Probando'
    p.año = '2014'
    post '/', p.to_json
    assert_equal 401, last_response.status
  end

  def test_crear_pelicula_ok
    p = Pelicula.new
    p.titulo = 'Probando'
    p.año = '2014'
    PeliculaBO.any_instance.expects(:crear_pelicula).with(anything, anything).returns(p)
    post '/', p.to_json, 'rack.session'=>{:usuario=>'launchpad'}
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos['titulo'], 'Probando'
  end

  def test_crear_peli_con_JSON_incorrecto
    post '/', 'hola pepito', 'rack.session'=>{:usuario=>'launchpad'}
         assert_equal 400, last_response.status
  end
end