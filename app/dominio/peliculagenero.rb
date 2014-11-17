require 'active_record'

class Peliculasgenero < ActiveRecord::Base
  belongs_to :pelicula
  belongs_to :genero
end