require 'active_record'

class Critica < ActiveRecord::Base
  belongs_to :pelicula
  belongs_to :usuario
end
