require 'active_record'

class Usuario < ActiveRecord::Base
  has_many :peliculas
  has_many :criticas
end
