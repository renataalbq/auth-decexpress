class AddMatriculaToGrades < ActiveRecord::Migration[7.0]
  def change
    add_column :grades, :matricula, :string
  end
end
