class CreateCritica < ActiveRecord::Migration
  def change
    create_table :criticas do |t|
      t.date :fecha
      t.string :texto
    end
  end
end