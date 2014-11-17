# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141117010820) do

  create_table "criticas", force: true do |t|
    t.date    "fecha"
    t.string  "texto"
    t.integer "pelicula_id"
    t.integer "usuario_id"
  end

  create_table "generos", force: true do |t|
    t.string "genero"
  end

  create_table "peliculas", force: true do |t|
    t.string  "titulo"
    t.string  "año"
    t.string  "duracion"
    t.string  "pais"
    t.string  "director"
    t.string  "guion"
    t.string  "musica"
    t.string  "fotografia"
    t.string  "reparto"
    t.string  "productora"
    t.string  "sinopsis"
    t.integer "usuario_id"
  end

  create_table "peliculas_generos", id: false, force: true do |t|
    t.integer "pelicula_id"
    t.integer "genero_id"
  end

  create_table "usuarios", force: true do |t|
    t.string "login"
    t.string "password"
  end

end
