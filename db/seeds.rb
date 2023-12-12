# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
professores = Teacher.create([{name: "João Silva"}, {name: "Maria Fernandes"}, {name: "Carlos Andrade"}, {name: "Mateus Borges"}, {name: "Ana Carla"} ])

Subject.create([
  {name: "Álgebra", teacher: professores[0]},
  {name: "Geometria", teacher: professores[0]},
  {name: "História", teacher: professores[1]},
  {name: "Geografia", teacher: professores[1]},
  {name: "Biologia", teacher: professores[2]},
  {name: "Física", teacher: professores[2]},
  {name: "Química", teacher: professores[2]},
  {name: "Português", teacher: professores[2]},
  {name: "Inglês", teacher: professores[2]}
])