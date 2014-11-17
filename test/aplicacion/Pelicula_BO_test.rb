require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'minitest/autorun'
require 'active_record'
require 'app/aplicacion/pelicula_BO'
require 'database_cleaner'


class PeliculaBOTest < Minitest::Test
  def setup
    ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        #cuidado, el path de la BD es relativo al fichero actual (__FILE__)
        #si cambiáis de sitio el test, habrá que cambiar el path
        :database  => File.join(File.dirname(__FILE__),'..', '..','db','cf_test.sqlite3')
    )
    #DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  def test_listar_peliculas
    lista = PeliculaBO.new.listar_peliculas()
    assert_equal 2, lista.length
    assert_equal '1971', lista[0]['año']
  end

  def test_crear_pelicula_ok
    datos = {'titulo'=>'Probando', 'año'=>'2014'}
    p = PeliculaBO.new.crear_pelicula(datos, 'launchpad')
    assert_equal 'Probando', p.titulo
    assert_equal 'launchpad', p.usuario.login
  end

  def test_crear_pelicula_sin_titulo
    datos = {'año'=>'2014'}
    error = assert_raises ValidacionError do
      p = PeliculaBO.new.crear_pelicula(datos, 'launchpad')
    end
    puts error.errores[:titulo]
  end

  def test_obtener_pelicula
    pelicula = PeliculaBO.new.obtener_pelicula(1)
    assert_equal 'Harold y Maude', pelicula.titulo
  end

  def test_buscar_pelicula_titulo
    pelicula = PeliculaBO.new.buscar_peliculas_titulo('Harold')
    assert_equal 1, pelicula.length
  end

  def test_buscar_pelicula_director
    pelicula = PeliculaBO.new.buscar_peliculas_director('Billy')
    assert_equal 1, pelicula.length
  end

  def test_buscar_pelicula_actores
    pelicula = PeliculaBO.new.buscar_peliculas_actor('Jack Lemmon')
    assert_equal 1, pelicula.length
  end

  def test_actualizar_pelicula
    datos = {'titulo'=>'Probando'}
    PeliculaBO.new.actualizar_pelicula(1,datos)
    pelicula = PeliculaBO.new.obtener_pelicula(1)
    assert_equal 'Probando', pelicula.titulo
  end

  def test_borrar_pelicula
    PeliculaBO.new.borrar_pelicula(1)
    peliculas = PeliculaBO.new.listar_peliculas()
    # habían dos películas, como he borrado una... pues eso
    assert_equal 1, peliculas.length
  end
end