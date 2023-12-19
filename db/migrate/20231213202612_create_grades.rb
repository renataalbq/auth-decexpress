class CreateGrades < ActiveRecord::Migration[7.0]
  def change
    create_table :grades do |t|
      t.string :nome
      t.string :matricula
      t.string :professor
      t.string :disciplina
      t.float :nota
      t.integer :bimestre
      t.string :email
      t.timestamps
    end
  end
end
