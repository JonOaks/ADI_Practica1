class CreateGeneros < ActiveRecord::Migration
  def change
    create_table :generos  do |t|
      t.string :genero
    end

    create_table :peliculas_generos, {:id=>false} do |t|
      t.belongs_to :pelicula
      t.belongs_to :genero
    end
  end
end
