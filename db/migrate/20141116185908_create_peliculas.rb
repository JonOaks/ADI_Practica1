class CreatePeliculas < ActiveRecord::Migration
  def change
    create_table :peliculas do |t|
      #El id no lo añadimos ya que lo hace automáticamente Active Record
      t.string :titulo
      t.string :año
      t.string :duracion
      t.string :pais
      t.string :director
      t.string :guion
      t.string :musica
      t.string :fotografia
      t.string :reparto
      t.string :productora
      t.string :sinopsis
    end

    change_table :criticas do |t|
      t.belongs_to :pelicula
    end
  end
end
