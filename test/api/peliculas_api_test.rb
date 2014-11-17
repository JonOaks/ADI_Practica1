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

#----TESTS REFERENTES PELICULAS----
  # existen dos películas en la base de datos
  def test_lista
    get '/'
    assert_equal last_response.status, 200
    datos = JSON.parse(last_response.body)
    assert_equal 2, datos.length
    assert_equal 'Harold y Maude',
                 datos[0]['titulo']
  end

  def test_obtener_pelicula
    get '/1'
    assert_equal last_response.status, 200
    datos = JSON.parse(last_response.body)
    assert_equal 'Harold y Maude', datos['titulo']
  end

  def test_obtener_pelicula_no_existente
    get '/3'
    assert_equal last_response.status, 404
  end

  def test_crear_pelicula_sin_autentificar
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

#----TESTS REFERENTES CRITICAS----
  # existe solo una crítica en la base de datos, está asociada a la película con id: 1

  def test_criticas
    get '/1/criticas'
    assert_equal last_response.status, 200
    datos = JSON.parse(last_response.body)
    assert_equal 1, datos.length
    assert_equal 'Magnífica',
                 datos[0]['texto']
  end

  def test_criticas_pelicula_no_existente
    get '/3/criticas'
    assert_equal last_response.status, 404
  end

  def test_obtener_critica
    get '/1/criticas/1'
    assert_equal last_response.status, 200
    datos = JSON.parse(last_response.body)
    assert_equal 'Magnífica', datos[0]['texto']
  end

  def test_obtener_critica_no_existente
    get '/1/criticas/3'
    assert_equal last_response.status, 404
  end

  def test_crear_critica_sin_autentificar
    c = Critica.new
    c.texto = 'Probando'
    post '/1/criticas', c.to_json
    assert_equal 401, last_response.status
  end

  def test_crear_critica_ok
    c = Critica.new
    c.texto = 'Probando'
    CriticaBO.any_instance.expects(:crear_critica).with(anything, anything, anything).returns(c)
    post '/1/criticas', c.to_json, 'rack.session'=>{:usuario=>'launchpad'}
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos['texto'], 'Probando'
  end

  def test_crear_critica_con_JSON_incorrecto
    post '/1/criticas', 'hola pepito', 'rack.session'=>{:usuario=>'launchpad'}
    assert_equal 400, last_response.status
  end
end