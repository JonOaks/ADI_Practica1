require 'active_record'

class Genero < ActiveRecord::Base
  # una película puede pertenecer a muchos géneros
  # un género puede tener muchas películas exponentes

  # esto es algo que no hice en mi propuesta práctica porque se me olvido
  # como, además, entregué un modelo de datos erróneo en el que habían dos relaciones muchos a muchos
  # donde en realidad tenían que haber dos relaciones 1 a muchos (peliculas-críticas, películas-comentarios)
  # procedo de este modo para suplir dichas carencias
  has_and_belongs_to_many :pelicula
end
