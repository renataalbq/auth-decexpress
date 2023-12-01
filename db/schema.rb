# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_01_031058) do
  create_table "documents", force: :cascade do |t|
    t.date "data_solicitacao"
    t.date "data_validade"
    t.string "tipo"
    t.string "matricula"
    t.string "cpf"
    t.string "nome_aluno"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email_aluno"
  end

  create_table "grades", force: :cascade do |t|
    t.string "professor"
    t.string "disciplina"
    t.float "nota"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.string "matricula"
    t.integer "bimestre"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "isAdmin"
  end

end
