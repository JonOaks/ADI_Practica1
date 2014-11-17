#Plantilla para crear capa de negocio y datos


Supongamos que tenemos terminada la capa REST y que la capa de negocio y datos funciona con *mocks*. Vamos a ver cómo implementar estas dos últimas capas. Este proceso debería ser incremental, es decir, Se recomienda seguirlo para cada funcionalidad nueva o cada entidad del modelo del dominio que queramos implementar.

En una primera iteración de ejemplo vamos a implementar  el método para listar los proyectos destacados (capa de negocio). Para ello necesitamos también la entidad del dominio `Proyecto` (capa de datos/dominio).


##0. ¿Dónde está la BD?

Respuesta corta: todavía en ningún sitio, la vamos a crear ahora. La respuesta algo más larga es:

- típicamente se usan 3 versiones de la BD: la de *desarrollo*, la de *testing* y la de *producción*. 
- El tipo de cada una de las 3 BD y la forma de conectar con ella se especifican por convención en un archivo `config/database.yml`. Si abrís el de la plantilla veréis que son bases de datos SQLite, guardadas en archivos locales (no hay un servidor de BD).
- La creación de la BD la vamos a hacer incrementalmente, según necesitemos las tablas y las relaciones entre ellas.

##1. Crear la estructura correspondiente de la BD


###1.1 Crear una migración

En *Active Record*, que es la librería ORM que estamos usando, cada añadido/modificación de la estructura de la BD se conoce como una *migración*. Es una serie de instrucciones expresadas en un DSL para crear/modificar/eliminar tablas, campos, relaciones entre tablas, ... 

Para crear una migración vacía usamos la herramienta `rake` (equivalente al `make` de C). Hay que darle un nombre. Usaremos el convenio típico de que para crear una tabla la migración empieza por `create\_`.

```bash
rake db:create_migration NAME=create_proyectos
#Nota: si el comando anterior falla, prueba con 
bundle exec rake db:create_migration NAME=create_proyectos
```

Si todo va bien, en la carpeta `db/migrate` se habrá creado un fichero de migración "semivacío" con el nombre especificado precedido de fecha/hora (la fecha/hora sirve para luego poder ejecutar las migraciones una tras otra de forma ordenada).

Dentro del método `change` colocamos el código para crear nuestra tabla. En [este tutorial](http://guides.rubyonrails.org/migrations.html) podéis ver algo más de información sobre el DSL para las migraciones.

```ruby
class CreateProyectos < ActiveRecord::Migration
  def change
    create_table :proyectos do |t|
      #El id no lo añadimos ya que lo hace automáticamente Active Record
      t.string :titulo
      t.text :descripcion
      #cantidad monetaria que queremos alcanzar
      t.integer :objetivo
      t.date :fecha_limite
      #por el momento tampoco añadimos las relaciones
      #Lo haremos en la siguiente iteración
    end
  end
end
```

###1.2 Ejecutar la migración de la BD

Para ejecutar la migración usamos `rake` desde la consola

```bash
#migración para crear la BD de desarrollo
rake db:migrate
#migración para crear la BD de testing
rake db:migrate RACK_ENV=test
#NOTA: si los comandos anteriores no te funcionan, precédelos de "bundle exec"
bundle exec rake db:migrate
bundle exec rake db:migrate RACK_ENV=test
```

En la carpeta `db` deben aparecer los `.sqlite3` correspondientes a las dos BD. Además aparece un `schema.rb` que contiene una especie de migración "maestra" donde se irán acumulando todos los cambios que hagamos sobre la estructura de la BD, de modo que solo haga falta ejecutar esta para obtener la BD completa.


##2. La capa de dominio y acceso a datos

Cambiar la clase `Proyecto` por la siguiente

```ruby
require 'active_record'

class Proyecto < ActiveRecord::Base
end
```

Por el momento la clase está vacía, ya que las variables de instancia se obtienen automáticamente de los campos de la correspondiente tabla en la BD. **Si ejecutamos ahora los test, fallarán**, ya que no hemos especificado cómo conectar con la BD. Aunque se puede hacer manualmente, también lo podemos hacer con la gema `sinatra-activerecord` (que leerá automáticamente el contenido de `config/database.yml`. En la aplicación REST hay que poner un 

```ruby
require 'sinatra-activerecord'
```


Ahora el test `proyectos_api_test` debería funcionar, ya que Active Record define automáticamente los *getters* y *setters* que antes definíamos manualmente (con `attr_accessor`) y también define automáticamente el `to_json`. 

> IMPORTANTE: aunque el test pase, todavía no estamos usando la BD "de verdad", estamos haciendo todas las operaciones en memoria.


Por el momento la capa de dominio no tiene sentido probarla, ya que no le hemos metido ninguna lógica, son solo *getters*, *setters* y el *to_json*, y eso no es necesario probarlo ya que la implementación la hace automáticamente active record (y debería ser correcta :) ).


##3. La capa de aplicación

##3.1 Cambio de la implementación

Ahora ya podemos implementar "de verdad" la capa de aplicación (o de negocio, como queramos llamarla). Por ejemplo, el método de `ProyectoBO` para listar los proyectos destacados pasaría a ser:

```ruby
  def listar_destacados
    Proyecto.where(:destacado=>true).order(:fecha_limite=>:asc)
  end
```


##3.2 Pruebas
 
###3.2.1. Rellenar la BD de datos para testing

Se ha creado la tabla `proyectos`, pero estará vacía. Para rellenarla con datos, ejecutar en la consola

```bash
rake db:fixture:load RACK_ENV=test
#Nota: si el comando anterior falla, prueba con 
bundle exec rake db:fixtures:load RACK_ENV=test
```

Esta orden carga los ficheros con datos de prueba contenidos en el directorio `test/fixtures`. Cada uno de ellos es un fichero en formato YAML con datos de prueba (*fixtures*). En la plantilla tienes un ejemplo con datos de proyectos: `proyectos.yml`. Puedes ver [más ejemplos de este formato](http://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures).

##3.2.2 Escribir las pruebas

Ya podemos escribir el código de prueba para el método `listar_destacados` de `ProyectoBO`. Será algo como

```ruby
def setup
    ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        #cuidado, el path de la BD es relativo al fichero actual (__FILE__)
        #si cambiáis de sitio el test, habrá que cambiar el path
        :database  => File.join(File.dirname(__FILE__),'..', '..','db','cf_test.sqlite3')
    )
end

def test_listar_destacados
    lista = ProyectoBO.new.listar_destacados()
    #En los fixtures tenemos 2 proyectos destacados
    assert_equal 2, lista.length
end
```

En esta capa es necesario establecer la conexión con la BD manualmente ya que aquí no funciona `sinatra-activerecord` que recordemos que lo hacía automáticamente.

##4 Pruebas de la capa REST


La capa REST ya está implementada y probada. Pero usábamos *mocks* de las capas inferiores. Podemos probar a sustituirlos por las capas "de verdad" para ver si sigue funcionando. Por ejemplo en `test_destacados` podríamos hacer

```ruby
def test_destacados
    get '/destacados'
    assert_equal last_response.status, 200
    datos = JSON.parse(last_response.body)
    #En los fixtures hay 2 proyectos destacados
    assert_equal datos.length, 2
    assert_equal 'Dar la vuelta al mundo en patinete', datos[0]['titulo']
end
```




