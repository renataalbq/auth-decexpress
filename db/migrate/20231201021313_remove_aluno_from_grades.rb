class RemoveAlunoFromGrades < ActiveRecord::Migration[7.0]
  def change
    remove_column :grades, :aluno, :string
  end
end
