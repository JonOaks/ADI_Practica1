require 'active_record'

class Pelicula < ActiveRecord::Base
  validates :titulo, presence: true
  #validates_presence_of :titulo
  has_many :criticas
  has_many :generos
  belongs_to :usuario
end
