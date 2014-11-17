require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'minitest/autorun'
require 'active_record'
require 'app/aplicacion/pelicula_BO'
require 'database_cleaner'

class CriticaBOTest < Minitest::Test
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

  def test_listar_criticas
    # solo hay una película con critica y es la que tiene como id = 1
    lista = CriticaBO.new.listar_criticas(1)
    assert_equal 1, lista.length
    assert_equal 'Magnífica', lista[0]['texto']
  end

  def test_crear_critica_ok
    datos = {'texto'=>'Probando'}
    p = CriticaBO.new.crear_critica(datos, 'launchpad', 1)
    assert_equal 'Probando', p.texto
  end

  def test_obtener_critica
    critica = CriticaBO.new.obtener_critica(1,1)
    assert_equal 1, critica.length
    assert_equal 'Magnífica', critica[0]['texto']
  end
end